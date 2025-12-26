
    #last_df = get_last_file(full_df, "Full_date")
    #
    #last_df = last_df[last_df['Volume_std']!=0]
    #
    #last_df['z_score'] =last_df.apply(lambda x: calc_z_score(x.Volume, x.Volume_mean,x.Volume_std), axis=1)
    #last_df['abs_z_score'] =last_df['z_score'].apply(lambda x: abs(x))   
    #last_df['Is_outlier'] =last_df.apply(lambda x: identify_outlier(x.abs_z_score, x.Volume_mean), axis=1)



        upload_data_to_postgres()

#offseted_day, offset_dt_string = get_offsetted_day(date = now,weekday=(1,2,5,6), offset_param=9)
#
#print(offset_dt_string)
#
#last_day_df = full_df[full_df["Full_date"]>= offset_dt_string]
#
#
#
#
#last_day_df = pd.pivot_table(last_day_df, values=['Volume_mean', 'Price_mean'], index=['Ticker'], columns=['Full_date'])
#
#last_day_df.columns = last_day_df.columns.map('{0[0]}|{0[1]}'.format)
#last_day_df.reset_index(inplace = True)
#
#grouped_by_ticker = full_df[['Ticker', 'Volume']].groupby('Ticker').agg(['mean',std])
#grouped_by_ticker.reset_index(inplace = True)
##grouped_by_ticker.rename(columns= {'Volume': 'Avg. Volume'}, inplace = True)
#grouped_by_ticker.columns = grouped_by_ticker.columns.get_level_values(0)
#grouped_by_ticker.columns = ['Ticker', 'Mean', 'St_dev']
##declining_df_pv
#last_day_df = last_day_df.merge(grouped_by_ticker, how = 'left')
#
#print(last_day_df)
#print(last_day_df.columns)
#
#last_df = add_column_based_on_confition(DataFrame=last_df, new_colname="average_volume_declining", condition_column="Ticker"\
#                                        , condition="isin", function=get_average_volume(DataFrame=last_day_df,parameter = 0.8))
#
#last_df = add_column_based_on_confition(DataFrame=last_df, new_colname="average_volume_price_declining", condition_column="Ticker"\
#                                        , condition="isin", function=get_declining_volume_price(DataFrame=last_day_df))
#
#last_df = add_column_based_on_confition(DataFrame=last_df, new_colname="average_volume_price_rising", condition_column="Ticker"\
#                                        , condition="isin", function=get_raising_volume_price(DataFrame=last_day_df))
#
#last_df = add_column_based_on_confition(DataFrame=last_df, new_colname="average_volume_declining", condition_column="Ticker"\
#                                        , condition="isin", function=get_declining_volume(DataFrame=last_day_df))
#