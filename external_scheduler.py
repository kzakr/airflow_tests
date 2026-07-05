#!/usr/bin/env python3
import argparse
import json
import os
import subprocess
import sys
import time
from datetime import datetime


def load_config(path: str) -> dict:
    with open(path, "r", encoding="utf-8") as handle:
        config = json.load(handle)

    if "schedule" not in config or not isinstance(config["schedule"], list):
        raise ValueError("Config must contain a 'schedule' list")

    return config


def get_state_path(config_path: str) -> str:
    base, ext = os.path.splitext(config_path)
    return f"{base}.state{ext}"


def load_state(path: str) -> dict:
    if not os.path.exists(path):
        return {"last_triggered": {}}

    with open(path, "r", encoding="utf-8") as handle:
        return json.load(handle)


def save_state(path: str, state: dict) -> None:
    with open(path, "w", encoding="utf-8") as handle:
        json.dump(state, handle, indent=2)


def normalize_day_of_week(day: int) -> int:
    if 0 <= day <= 6:
        return day + 1
    if 1 <= day <= 7:
        return day
    raise ValueError(f"Unsupported day value: {day}")


def get_latest_run_state(dag_id: str) -> str | None:
    command = [sys.executable, "-m", "airflow", "dags", "list-runs", "--dag-id", dag_id, "--limit", "1", "-o", "json"]
    result = subprocess.run(command, capture_output=True, text=True)

    if result.returncode != 0:
        return None

    try:
        payload = json.loads(result.stdout or "[]")
    except json.JSONDecodeError:
        return None

    if isinstance(payload, list) and payload:
        return payload[0].get("state")

    if isinstance(payload, dict):
        dag_runs = payload.get("dag_runs") or []
        if dag_runs:
            return dag_runs[0].get("state")

    return None


def should_run(entry: dict, now: datetime) -> bool:
    if "hour" in entry and now.hour != int(entry["hour"]):
        return False

    if "minute" in entry and now.minute != int(entry["minute"]):
        return False

    if "second" in entry and now.second != int(entry["second"]):
        return False

    if "days_of_week" in entry:
        allowed_days = {normalize_day_of_week(day) for day in entry["days_of_week"]}
        if normalize_day_of_week(now.weekday()) not in allowed_days:
            return False

    depends_on = entry.get("depends_on") or []
    if isinstance(depends_on, str):
        depends_on = [depends_on]

    for upstream_dag in depends_on:
        upstream_state = get_latest_run_state(upstream_dag)
        if upstream_state != "success":
            return False

    return True


def trigger_dag(dag_id: str, run_id: str) -> None:
    env = os.environ.copy()
    command = [sys.executable, "-m", "airflow", "dags", "trigger", dag_id, "--run-id", run_id]
    print(f"Triggering DAG {dag_id} with run_id {run_id}")
    result = subprocess.run(command, capture_output=True, text=True, env=env)
    if result.returncode != 0:
        print(result.stderr or result.stdout)
        raise RuntimeError(f"Failed to trigger DAG {dag_id}")


def run_scheduler(config_path: str, check_interval_seconds: int, once: bool) -> None:
    config = load_config(config_path)
    interval = int(config.get("check_interval_seconds", check_interval_seconds))
    state_path = get_state_path(config_path)
    state = load_state(state_path)
    last_triggered = state.get("last_triggered", {})

    print(f"External scheduler started with config: {config_path}")
    while True:
        now = datetime.now()
        current_minute = now.strftime("%Y-%m-%d %H:%M")

        for entry in config["schedule"]:
            dag_id = entry["dag_id"]
            key = f"{dag_id}:{current_minute}"
            if key in last_triggered:
                continue

            if should_run(entry, now):
                trigger_dag(dag_id, f"external_scheduler_{now.strftime('%Y%m%d%H%M%S')}")
                last_triggered[key] = now.isoformat()
                state["last_triggered"] = last_triggered
                save_state(state_path, state)

        if once:
            break

        time.sleep(interval)


def main() -> None:
    parser = argparse.ArgumentParser(description="External scheduler for Airflow DAGs")
    parser.add_argument("--config", default="external_scheduler_config.json", help="Path to the JSON config file")
    parser.add_argument("--check-interval", type=int, default=30, help="Seconds between scheduler checks")
    parser.add_argument("--once", action="store_true", help="Run one check and exit")
    args = parser.parse_args()

    run_scheduler(args.config, args.check_interval, args.once)


if __name__ == "__main__":
    main()
