import sqlite3 as sql

import numpy as np
import pandas as pd
import plotly.express as px
import streamlit as st
import utils

st.set_page_config(page_title="QuestionPage1",
                   page_icon="3️⃣",
                   layout="wide",
                   initial_sidebar_state="expanded")
utils.show_page()


def side_bar():
    global show_task1, show_task2, show_task3, show_task4
    with st.sidebar:
        # show_code = st.checkbox("查看代码")
        st.markdown("# 操作选项：")
        show_task1 = st.checkbox("查看任务 1")
        show_task2 = st.checkbox("查看任务 2")
        show_task3 = st.checkbox("查看任务 3")
        show_task4 = st.checkbox("查看任务 4")


def main():
    global show_task1, show_task2, show_task3, show_task4

    st.markdown('''
        # 📑 全国产业结构变化及区域差异
        ---
        ## 项目任务
        1. [x] 查询分析指定时间周期一个区域的第一、二、三产业的产值占比分布及其变化
        2. [x] 比较指定时间周期各区域的第一、二、三产业的产值占比
        3. [x] 产业结构“三二一”模式，即第一产业占比最少，以第二产业和第三产业为主导，其中第三产业占比大于第二产业，符合经济发展的协调性。分析疫情对产业结构的影响，对哪种产业影响最严重。例如，在疫情发生前，哪些区域的产业结构不是“三二一”模式，占比多少；在疫情发生后，哪些区域的产业结构不是“三二一”模式，占比多少
        4. [x] 分析在2020~2022年产业结构变化与湖北省最相似的三个省份。在衡量产业结构时，采用第二、三产业同比增长值(或增长率)的比值进行测度
        ''')

    # if show_code:
    #     utils.show_code(__file__)

    if show_task1:
        pass

    if show_task2:
        pass

    if show_task3:
        pass

    if show_task4:
        pass


utils.processing(__file__)
side_bar()
main()
