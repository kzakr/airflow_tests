import os
#from sklearn.metrics import confusion_matrix
import numpy as np
from py_files.logging_utils import get_logger
#from matplotlib import pyplot as plt

logger = get_logger(__name__)



def dt_model(X_train, X_test, y_train, y_test):
    #from sklearn import tree
    from sklearn.tree import DecisionTreeClassifier, plot_tree
    
    feature_names = X_train.columns.to_list()
    dt = DecisionTreeClassifier(random_state=435,max_depth = 3, ccp_alpha = 0.01)
    dt.fit(X_train, y_train)

    logger.info("Decision Tree Score: %s", dt.score(X_test, y_test))
    #print(confusion_matrix(y_test, dt.predict(X_test)))
        #_, ax = plt.subplots(figsize=(60,60)) # Resize figure
    #plot_tree(dt, filled=True, ax=ax, feature_names = feature_names)
    #print(os.getcwd())
    #print("t()"*34)
    #plt.savefig('dec_tree.png')

    return dt

def ct_model(X_train, X_test, y_train, y_test):
    from sklearn.ensemble import RandomForestClassifier
    logger.debug("Random forest feature count: %s", len(X_test.columns))
    #print(X_test.columns[12:])
    #X_test[X_test.columns[13:]]=1
    clf = RandomForestClassifier(max_depth=8, random_state=0,class_weight ={0:.2, 1: .8})
    clf.fit(X_train, y_train)

    logger.info("Classification Tree Score: %s", clf.score(X_test, y_test))
    #print(confusion_matrix(y_test, clf.predict(X_test)))
    return clf

def svm_model(X_train, X_test, y_train, y_test):
    from sklearn.svm import LinearSVC
    from sklearn.preprocessing import StandardScaler
    from sklearn.pipeline import make_pipeline

    svm =  LinearSVC(random_state=0,penalty = 'l1',loss='squared_hinge', dual=False, tol=1e-3,C =2)
    svm.fit(X_train, y_train)

    logger.info("SVM Score: %s", svm.score(X_test, y_test))

    return svm

def gbc_model(X_train, X_test, y_train, y_test):
    from sklearn.ensemble import GradientBoostingClassifier

    gbc = GradientBoostingClassifier( max_depth=7)
    gbc.fit(X_train,y_train)

    logger.info("Gradient Boost Score: %s", gbc.score(X_test, y_test))

    return gbc

