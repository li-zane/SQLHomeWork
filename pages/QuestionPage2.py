import sqlite3 as sql

import numpy as np
import pandas as pd
import plotly.express as px
import streamlit as st
from st_pages import Page, add_page_title, show_pages

show_pages([
    Page("./HomePage.py", "项目介绍", "👋🏼"),
    Page("./pages/QuestionPage1.py", "问题1", "1️⃣"),
    Page("./pages/QuestionPage2.py", "问题2", "2️⃣"),
    Page("./pages/QuestionPage3.py", "问题3", "3️⃣"),
    Page("./pages/QuestionPage4.py", "问题4", "4️⃣")
])
st.set_page_config(page_title="QuestionPage2",
                   page_icon="2️⃣",
                   layout="wide",
                   initial_sidebar_state="expanded")


def side_bar():
    global show_code, show_task1, show_task2, show_task3, show_task4
    with st.sidebar:
        show_code = st.checkbox("查看代码")
        show_task1 = st.checkbox("查看任务 1")
        show_task2 = st.checkbox("查看任务 2")
        show_task3 = st.checkbox("查看任务 3")
        show_task4 = st.checkbox("查看任务 4")


def main():
    global show_code, show_task1, show_task2, show_task3, show_task4

    st.markdown('''
        # 📑 全国生产总值增长趋势及区域差异
        ---
        ## 项目任务
        1. [x] 分析在指定时间周期内一个省会城市的生产总值变化趋势与其所在省的趋势是否相似。查询最相似的三个城市和差异最大的三个城市
        2. [x] 分析是否存在一些省会城市在指定时间周期的人均GDP低于其所在的省份，若有，请输出城市和其所属省份的名称及其GDP差值，否则输出在指定时间周期内不存在
        3. [x] 分析在新冠肺炎疫情三年(20220~2022)中，哪些省份在2020年GDP同比下降，2021年同比增加，2022年同比下降，计算这些省份在所有省份的占比。 在这些省份中，哪些省份的省会城市的三年GDP同比增加，并计算这些省会城市在所有省会城市和直辖市的占比
        4. [x] 分析比较在2017、2018、2019、2020、2021和2022 GDP同比增长率最高的3个区域和最低的3个区域
        ''')

    if show_code:
        with open(__file__, 'r', encoding='utf-8') as r:
            code = r.read()

        st.markdown('''
                    ---
                    ## 项目代码
                    ''')
        st.code(code, 'python')

    if show_task1:
        pass

    if show_task2:
        pass

    if show_task3:
        pass

    if show_task4:
        pass


side_bar()
main()
