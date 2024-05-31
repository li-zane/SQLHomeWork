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

st.set_page_config(page_title="BabySQL",
                   page_icon="👋",
                   layout="wide",
                   initial_sidebar_state="expanded")

show_code = False  # 展示代码


def sidebar():
    global show_code
    with st.sidebar:
        st.markdown("# 操作选项：")
        show_code = st.checkbox('查看代码')


def main():
    global show_code
    st.markdown('''
                
                # 👋🏼 ICPEG 数据库设计与应用

                ---

                ## 作者与分工

                - **张芮嘉**：
                - **何羽涵**：
                - **AIGC**：
                
                ---

                ## 项目内容

                - **问题1**：
                - **问题2**：
                - **问题3**：
                - **问题4**：
                - **扩展内容**：
                - **页面设计**：采用 **streamlit** 模块制作 Web APP，用 **sqlite3** 模块创建、管理、使用数据库，用 **plotly** 库展示数据分析图。
                
                ---

                ## 项目架构
                
                ''')

    st.code(
        r'''
        SQLHomeWork/ 
        |
        |—— HomePage.py
        |—— requirements.txt
        |—— pages/
        | |—— QuestionPage1.py
        | |—— QuestionPage2.py
        | |—— QuestionPage3.py
        | |—— QuestionPage4.py
        ''', 'markdown')

    if show_code:
        with open(__file__, 'r', encoding='utf-8') as r:
            code = r.read()

        st.markdown('''
                    ---
                    ## 项目代码
                    ''')
        st.code(code, language='python')


sidebar()
main()
