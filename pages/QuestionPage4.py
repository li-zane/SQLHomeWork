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
st.set_page_config(page_title="QuestionPage1",
                   page_icon="4️⃣",
                   layout="wide",
                   initial_sidebar_state="expanded")


def side_bar():
    global show_code, show_task1, show_task2, show_task3, show_task4, show_task5
    with st.sidebar:
        show_code = st.checkbox("查看代码")
        show_task1 = st.checkbox("查看任务 1")
        show_task2 = st.checkbox("查看任务 2")
        show_task3 = st.checkbox("查看任务 3")
        show_task4 = st.checkbox("查看任务 4")
        show_task5 = st.checkbox("查看任务 5")


def main():
    global show_code, show_task1, show_task2, show_task3, show_task4, show_task5

    st.markdown('''
        # 📑 居民收入变化及区域差异
        ---
        ## 项目任务
        1. [x] 分析比较各区域各项收入占比的变化
        2. [x] 查询分析在指定时间周期区域居民收入最高的3个区域和最低的3个区域的以及它们的人口特征，包括人口数量、人口密度，等等。人口密度用人口数量/区域面积得到，可不用另行采集存人口密度数据
        3. [x] 如果将居民收入划分为高、中、低三个等级，给每个区域收入赋予等级，将结果存储在数据库中，并且统计在指定时间周期各种等级的区域数量。查询哪些区域居民收入一直位于高等级，哪些一直位于低等级。注意不同时间周期划分高中低等级的标准不同。
        4. [x] 比较东部、西部、中部、东北部地区的居民收入的环比增长率
        5. [x] 在新冠肺炎疫情三年(20220~2022)中，哪些区域居民收入同比年增长率下降？
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

    if show_task5:
        pass


side_bar()
main()
