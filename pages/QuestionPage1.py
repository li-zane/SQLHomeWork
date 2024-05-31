import sqlite3 as sql
import time

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
                   page_icon="1️⃣",
                   layout="wide",
                   initial_sidebar_state="expanded")

# Add a placeholder
# latest_iteration = st.empty()
# bar = st.progress(0)

# for i in range(30):
#     # Update the progress bar with each iteration.
#     latest_iteration.text(f'Iteration {i+1}')
#     bar.progress(i + 1)
#     time.sleep(0.1)
# '...and now we\'re done!'


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
        # 📑 固定资产投资及社会消费品零售总额
        ---
        ## 项目任务
        1. [x] 分析在指定时间周期一个区域的固定资产总投资规模和各种经济类型的投资规模占比。类型包括国有经济、集体经济、私营经济、股份制经济，等等
        2. [x] 分析在指定时间周期各个区域的固定资产投资的差异，例如，固定资产投资最高的区域和最低的区域，各区域排名
        3. [x] 湖北省是疫情最严重的省份。分析在疫情期间湖北省的国有经济投资增速和私营经济投资增速在全国在所有省份和直辖市的排名
        4. [x] 分析在新冠肺炎疫情三年(20220~2022)中，哪些省份社会消费品零售总额在2020年同比下降，2021年同比增加，2022年同比下降，计算这些省份在所有省份和直辖市的占比。湖北省在其中吗？
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
