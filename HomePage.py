import sqlite3 as sql

import numpy as np
import pandas as pd
import plotly.express as px
import streamlit as st

st.set_page_config(page_title="BabySQL",
                   page_icon="👋",
                   layout="wide",
                   initial_sidebar_state="expanded")

from st_pages import Page, add_page_title, show_pages

show_pages([
    Page("./HomePage.py", "项目介绍", "👋🏼"),
    Page("./pages/QuestionPage1.py", "问题1", "1️⃣"),
    Page("./pages/QuestionPage2.py", "问题2", "2️⃣"),
    Page("./pages/QuestionPage3.py", "问题3", "3️⃣"),
    Page("./pages/QuestionPage4.py", "问题4", "4️⃣")
])

show_arrangements = False  # 展示分工
show_content = False  # 展示内容
show_code = False  # 展示全部代码
with st.sidebar:
    st.markdown("# 操作选项：")
    show_arrangements = st.checkbox('查看分工')
    show_content = st.checkbox('项目大纲')
    show_code = st.checkbox('查看代码')

st.markdown('# 👋🏼 张芮嘉&何羽涵&AI 的数据库项目作业')

if show_arrangements:
    st.markdown('''
    ## 分工合作
    ''')

if show_content:
    st.markdown('''
    ## 项目大纲
    ''')

# with st.expander('项目代码', expanded=show_code):
#     st.markdown("""

#         import

#         """)

# st.sidebar.success("Select a demo above.")
