import pandas as pd
import plotly.express as px
import requests as re
import streamlit as st
import utils

st.set_page_config(page_title="扩展",
                   page_icon="🥳",
                   layout="wide",
                   initial_sidebar_state="expanded")
utils.show_page()


def show_results_func():
    if 'fig' in st.session_state.keys():
        print('olla')
        return

    with re.get('https://geo.datav.aliyun.com/areas_v3/bound/100000_full.json'
                ) as response:
        counties = response.json()

    data = pd.read_csv(
        "https://raw.githubusercontent.com/li-zane/SQLHomeWork/main/Data/省份等级的灯光值_平均值.CSV",
        index_col=0,
        usecols=[0, 1, 2] + list(range(4, 35)),
        dtype={
            'PR_ID': int
        }).melt(id_vars=['PR', 'PR_ID'],
                var_name='DATE',
                value_name='Light_Intensity')

    # 创建一个 Plotly 地图，展示每年各省的光照强度

    fig = px.choropleth_mapbox(
        data_frame=data,
        geojson=counties,
        featureidkey="properties.adcode",  # geojson 文件中用于连接的键
        locations='PR_ID',  # 地理位置的数据列
        color='Light_Intensity',  # 颜色映射到光照强度
        hover_name='PR',  # 悬停时显示的名称
        # hover_data=['DATE', 'Light_Intensity']
        custom_data='PR_ID',
        labels={'Light_Intensity': '年平均光照强度'},
        range_color=(0, 15),
        color_continuous_scale="Viridis",
        zoom=3,
        mapbox_style="white-bg",
        animation_frame='DATE',  # 创建动画的帧（年份）
        center={
            "lat": 37,
            "lon": 112
        },
        title='中国各省年平均光照强度变化图')

    # 更新地图布局, 美化图像
    fig.update_geos(
        visible=False,  # 隐藏地理边框
        fitbounds="locations"  # 地图缩放到数据范围
    )
    fig.update_layout(
        coloraxis_colorbar={
            'title': '光照强度',
        },
        width=1500,  # 设置宽度
        height=1000,  # 设置高度
        margin={
            "r": 0,
            "t": 0,
            "l": 0,
            "b": 0
        },  # 调整边距
        title_x=0.5,  # 标题居中
        title_y=0.95)

    st.session_state['fig'] = fig

    # # 显示地图
    # fig.show()


def side_bar():
    global show_code, show_results
    with st.sidebar:
        st.markdown("# 操作选项：")
        show_code = st.checkbox("查看 SQL 代码")
        show_results = st.checkbox("查看成果")


def main():
    global show_code, show_results

    st.markdown('''
        # 📑 1992 - 2022 中国各省份年平均夜间灯光强度变化展示
        ---
        ## 项目任务
        1. [x] 收集分析数据
        2. [x] 绘制年平均夜间灯光强度变化图
        ''')

    if show_code:
        code = ""
        st.markdown('''
            ---
            ## 项目代码
            ''')

    if show_results:
        st.markdown('''
            ---
            ## 项目成果
            ''')
        show_results_func()
        st.plotly_chart(st.session_state['fig'])


utils.processing(__file__)
side_bar()
main()
