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
'Starting a long computation...'

# Add a placeholder
latest_iteration = st.empty()
bar = st.progress(0)

for i in range(30):
    # Update the progress bar with each iteration.
    latest_iteration.text(f'Iteration {i+1}')
    bar.progress(i + 1)
    time.sleep(0.1)
'...and now we\'re done!'
