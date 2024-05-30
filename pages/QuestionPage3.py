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
                   page_icon="3️⃣",
                   layout="wide",
                   initial_sidebar_state="expanded")
