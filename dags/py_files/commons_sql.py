from py_files.commons import get_time, quarter_back, add_working_days, iterative_list
from py_files.logging_utils import get_logger

logger = get_logger(__name__)

def get_max_date( time_column:str = "full_date", table:str = "finviz_result")->str:
    statement = f"select max({time_column}) from {table}"

    return (statement)


def get_day_part(how_many_day:int ,  after_day: int ):
    _day_part = f"select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > {after_day}) order by full_date desc limit {how_many_day}"
    return _day_part

def get_day_part_yahoo(how_many_day:int ,  after_day: str ):
    _day_part = f"select distinct _date from yahoo_result where _date not in (select distinct _date from yahoo_result where _date > '{after_day}') order by _date desc limit {how_many_day}"
    return _day_part


def cut_training_period(how_many_day:int,  after_day: int , to_date_interval:int = 20)->int:
    if how_many_day < to_date_interval+10:
         logger.warning('to_date_interval %s +10 parameter cannot be higher than how_many_day %s', to_date_interval, how_many_day)
    cut_off_date = int(add_working_days(date_as_int = after_day,num_days = -to_date_interval))
    return cut_off_date


def cut_training_period_yahoo(how_many_day:int,  after_day: int , to_date_interval:int = 20)->int:
    if how_many_day < to_date_interval+10:
         logger.warning('to_date_interval %s +10 parameter cannot be higher than how_many_day %s', to_date_interval, how_many_day)
    cut_off_date = str(add_working_days(date_as_int = after_day,num_days = -to_date_interval, format = "%Y-%m-%d"))
    return cut_off_date