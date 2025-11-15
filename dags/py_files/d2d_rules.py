import pandas as pd
import os


def volume_below_08_average(DataFrame: pd.DataFrame, column_name:str, multiplicator: float)->[]:

    ticker_list = DataFrame[column_name][(DataFrame.iloc[:,7]<multiplicator*DataFrame.iloc[:,11])\
                                        &(DataFrame.iloc[:,8]<multiplicator*DataFrame.iloc[:,11])\
                          &(DataFrame.iloc[:,9]<multiplicator*DataFrame.iloc[:,11])\
                                        &(DataFrame.iloc[:,10]<multiplicator*DataFrame.iloc[:,11])]
    return ticker_list

def sql_volume_below_08_average(DataFrame: pd.DataFrame, column_name:str, multiplicator: float)->[]:

    ticker_list = DataFrame[column_name][(DataFrame["volume"]<multiplicator*DataFrame["avg_volume"])\
                                        &(DataFrame["volume_one_day_back"]<multiplicator*DataFrame["avg_volume"])\
                          &(DataFrame["volume_two_days_back"]<multiplicator*DataFrame["avg_volume"])\
                                       ]
    return ticker_list
                              


def volume_and_price_declining_3(DataFrame: pd.DataFrame, column_name:str)->list():
    ticker_list = DataFrame[column_name][(DataFrame["volume"]>DataFrame["volume_one_day_back"])\
                          &(DataFrame["volume_one_day_back"]>DataFrame["volume_two_days_back"])\
                              
                             (DataFrame["price"]>DataFrame["price_one_day_back"])&(DataFrame["price_one_day_back"]>DataFrame["price_two_days_back"])]

    return ticker_list

def sql_volume_and_price_declining_3(DataFrame: pd.DataFrame, column_name:str)->list():
    ticker_list = DataFrame[column_name][(DataFrame["volume"]<DataFrame["volume_one_day_back"])\
                          &(DataFrame["volume_one_day_back"]<DataFrame["volume_two_days_back"])\
                              &(DataFrame["price"]<DataFrame["price_one_day_back"])&\
                             (DataFrame["price_one_day_back"]<DataFrame["price_two_days_back"])]

    return ticker_list



def volume_and_price_raising_3(DataFrame: pd.DataFrame, column_name:str)->list():
    ticker_list = DataFrame[column_name][(DataFrame.iloc[:,7]<DataFrame.iloc[:,8])\
                          &(DataFrame.iloc[:,8]<DataFrame.iloc[:,9])\
                              &(DataFrame.iloc[:,9]<DataFrame.iloc[:,10])&\
                             (DataFrame.iloc[:,2]<DataFrame.iloc[:,3])&(DataFrame.iloc[:,3]<DataFrame.iloc[:,4])\
                          &(DataFrame.iloc[:,4]<DataFrame.iloc[:,5])]
    return ticker_list

def sql_volume_and_price_raising_3(DataFrame: pd.DataFrame, column_name:str)->list():
    ticker_list = DataFrame[column_name][(DataFrame["volume"]>DataFrame["volume_one_day_back"])\
                          &(DataFrame["volume_one_day_back"]>DataFrame["volume_two_days_back"])\
                              &(DataFrame["price"]>DataFrame["price_one_day_back"])&\
                             (DataFrame["price_one_day_back"]>DataFrame["price_two_days_back"])]
    return ticker_list



def volume_declining_3(DataFrame: pd.DataFrame, column_name:str)->list():
    ticker_list = DataFrame[column_name][(DataFrame.iloc[:,7]>DataFrame.iloc[:,8])\
                          &(DataFrame.iloc[:,8]>DataFrame.iloc[:,9])\
                              &(DataFrame.iloc[:,9]>DataFrame.iloc[:,10])]
    return ticker_list

def sql_volume_declining_3(DataFrame: pd.DataFrame, column_name:str)->list():
    ticker_list = DataFrame[column_name][(DataFrame["volume"]<DataFrame["volume_one_day_back"])\
                          &(DataFrame["volume_one_day_back"]<DataFrame["volume_two_days_back"])
                          ]
    return ticker_list


def price_declining_3(DataFrame: pd.DataFrame, column_name:str)->list():
    ticker_list = DataFrame[column_name][(DataFrame.iloc[:,2]>DataFrame.iloc[:,3])\
                          &(DataFrame.iloc[:,3]>DataFrame.iloc[:,4])\
                              &(DataFrame.iloc[:,4]>DataFrame.iloc[:,5])
                            ]
    return ticker_list

def sql_price_declining_3(DataFrame: pd.DataFrame, column_name:str)->list():
    ticker_list = DataFrame[column_name][(DataFrame["price"]<DataFrame["price_one_day_back"])\
                          &(DataFrame["price_one_day_back"]<DataFrame["price_two_days_back"])\
                            ]
    return ticker_list


def volume_price_declining_2(DataFrame: pd.DataFrame, column_name:str)->list():
    ticker_list = DataFrame[column_name][(DataFrame.iloc[:,8]>DataFrame.iloc[:,9])\
                              &(DataFrame.iloc[:,9]>DataFrame.iloc[:,10])&\
                             (DataFrame.iloc[:,3]>DataFrame.iloc[:,4])\
                          &(DataFrame.iloc[:,4]>DataFrame.iloc[:,5])]
    
    return ticker_list

def sql_volume_price_declining_2(DataFrame: pd.DataFrame, column_name:str)->list():
    ticker_list = DataFrame[column_name][(DataFrame["price"]<DataFrame["price_one_day_back"])\
                          &(DataFrame["price_one_day_back"]<DataFrame["price_two_days_back"])\
                             &(DataFrame["volume"]<DataFrame["volume_one_day_back"])\
                          &(DataFrame["volume_one_day_back"]<DataFrame["volume_two_days_back"])
                          ]
    
    return ticker_list



def volume_declining_with_multiplicator(DataFrame: pd.DataFrame, column_name:str, multiplicator: float)->list():
    ticker_list = DataFrame[column_name][(DataFrame.iloc[:,7]>float*DataFrame.iloc[:,8])\
                          &(DataFrame.iloc[:,8]>float*DataFrame.iloc[:,9])\
                              &(DataFrame.iloc[:,9]>float*DataFrame.iloc[:,10])]
    return ticker_list



def sql_volume_declining_with_multiplicator(DataFrame: pd.DataFrame, column_name:str, multiplicator: float)->list():
    ticker_list = DataFrame[column_name][(DataFrame["volume"]*float<DataFrame["volume_one_day_back"])\
                          &(DataFrame["volume_one_day_back"]*float<DataFrame["volume_two_days_back"])
                          ]
    return ticker_list