import os
#from sklearn.metrics import confusion_matrix
import numpy as np
#from matplotlib import pyplot as plt



def dt_model(X_train, X_test, y_train, y_test):
    #from sklearn import tree
    from sklearn.tree import DecisionTreeClassifier, plot_tree
    
    feature_names = X_train.columns.to_list()
    dt = DecisionTreeClassifier(random_state=435,max_depth = 3, ccp_alpha = 0.01)
    dt.fit(X_train, y_train)

    print("Decision Tree Score: ", dt.score(X_test,y_test) )
    #print(confusion_matrix(y_test, dt.predict(X_test)))
        #_, ax = plt.subplots(figsize=(60,60)) # Resize figure
    #plot_tree(dt, filled=True, ax=ax, feature_names = feature_names)
    #print(os.getcwd())
    #print("t()"*34)
    #plt.savefig('dec_tree.png')
    print("KUpa"*43)

    return dt

def ct_model(X_train, X_test, y_train, y_test):
    from sklearn.ensemble import RandomForestClassifier
    print(len(X_test.columns))
    #print(X_test.columns[12:])
    #X_test[X_test.columns[13:]]=1
    clf = RandomForestClassifier(max_depth=8, random_state=0,class_weight ={0:.2, 1: .8})
    clf.fit(X_train, y_train)

    print("Clasyfication Tree Score: ", clf.score(X_test, y_test) )
    print("*"*23)
    #print(confusion_matrix(y_test, clf.predict(X_test)))
    return clf




