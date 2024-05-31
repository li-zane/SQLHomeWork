import time

import streamlit as st
from st_pages import Page, add_page_title, show_pages


@st.cache_resource
def show_page():
    show_pages([
        Page("./HomePage.py", "项目介绍", "👋🏼"),
        Page("./pages/QuestionPage1.py", "问题1", "1️⃣"),
        Page("./pages/QuestionPage2.py", "问题2", "2️⃣"),
        Page("./pages/QuestionPage3.py", "问题3", "3️⃣"),
        Page("./pages/QuestionPage4.py", "问题4", "4️⃣")
    ])


@st.cache_data
def show_code(file):
    with open(file, 'r', encoding='utf-8') as r:
        code = r.read()

        st.markdown('''
                        ---
                        ## 项目代码
                        ''')
        st.code(code, language='python')


# @st.cache_data
def processing(page):
    if page not in st.session_state:
        st.session_state[page] = 'Viewed'
    else:
        return
    process_text = "初次加载，请等待..."
    bar = st.progress(0, text=process_text)

    for t in range(100):
        time.sleep(0.01)
        bar.progress(t + 1, text=process_text)
    time.sleep(1)
    bar.empty()
    return None
