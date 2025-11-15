import os
import pydantic
from pydantic import BaseModel
import datetime
from datetime import datetime
from enum import Enum, auto

class CommonAttributes(BaseModel):
    downloads: str = r"C:\Users\kzakr\Downloads"
    finwiz_files: str = r"C:\Users\kzakr\Documents\Airflow_Docker_integr\airflow_tests\dags\output_files"



class CommonConditions(Enum):
    isin= "isin"
    higher= "higher"
    equal_or_higher= "equal_or_higher"
    lower= "lower"
    equal_or_lower= "equal_or_lower"
    equal= "equal"
    str_contains = "str_contains"
    str_not_contains = "str_not_contains"


class JoinOperators(Enum):
    Join= "JOIN"
    LeftJoin= "LEFT JOIN"
    RightJoin= "RIGHT JOIN"
    FullJoin= "FULL JOIN"
    OuterJoin= "OUTER JOIN"




