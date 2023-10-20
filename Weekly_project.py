import pandas as pd 
import dash
from dash import Dash, dcc, html, callback
from dash.dependencies import Input, Output, State
import plotly.express as px
from dash import dash_table
import dash_bootstrap_components as dbc
from sqlalchemy import create_engine


#############################

#Define data frame
db_connection = "postgresql://postgres:65349115@34.32.37.8/climate"

engine = create_engine(db_connection)

sql_query = "SELECT * FROM prep_temp"

df = pd.read_sql(sql_query, engine)

df['country'] = df['country'].str.replace('"', '')
df['city'] = df['city'].str.replace('"', '')
df['region'] = df['region'].str.replace('"', '')
df['avgtemp_c'] = df['avgtemp_c'].astype(int)

###########################

cities = ['Berlin', 'Kuala Lumpur', 'London']
df_weather = df[df['city'].isin(cities)]
df_weather = df_weather[['city','country','avgtemp_c','season']]
df_weather_grp = df_weather.groupby(['city','country','season']).mean()

############################

table = dash_table.DataTable(df_weather_grp.to_dict('records'),
                                  [{"name": i, "id": i} for i in df_weather_grp.columns],
                               style_data={'color': 'white','backgroundColor': "#222222"},
                              style_header={
                                  'backgroundColor': 'rgb(210, 210, 210)',
                                  'color': 'black','fontWeight': 'bold'}, 
                                     style_table={ 
                                         'minHeight': '400px', 'height': '400px', 'maxHeight': '400px',
                                         'minWidth': '900px', 'width': '900px', 'maxWidth': '900px',
                                         'marginLeft': 'auto', 'marginRight': 'auto',
                                         'marginTop': 0, 'marginBottom': "30"}
                            )                                     

##############################


df_countries =df[df['country'].isin(['Germany', 'London', 'Malaysia'])]

min_temp = 0  # Adjust the minimum temperature value
max_temp = 30  # Adjust the maximum temperature value
midpoint = (min_temp+max_temp)/ 2
color_scale = [(0, 'blue'), (min_temp/ (max_temp - min_temp), 'blue'),
              (1, 'red')]
fig = px.bar(df_countries, x='date', y='avgtemp_c', color='avgtemp_c',
             color_continuous_scale=color_scale,
             color_continuous_midpoint=midpoint,
             labels={'avg_temp': 'Average Temperature (°C)'},
             title='Temperature Variation Throughout the Year in Cities')

fig.update_layout(xaxis_title='Date', yaxis_title='Average Temperature (°C)')
fig = fig.update_layout(
        plot_bgcolor="black", paper_bgcolor="#222222", font_color="white")
graph = dcc.Graph(figure=fig)
###############################
db_connection2 = "postgresql://postgres:65349115@34.32.37.8/climate"

engine2 = create_engine(db_connection2)

sql_query2 = "SELECT * FROM max_min_temp_yearly"

df_max_min_temp = pd.read_sql(sql_query2, engine2)
df_max_min_temp['country'] = df_max_min_temp['country'].str.replace('"', '')
df_max_min_temp['city'] = df_max_min_temp['city'].str.replace('"', '')

#############################



fig2 = px.line(df_max_min_temp, x='country', y=["max_maxtemp", "min_mintemp"], height=500, title="maximum temprature of countries", markers=True, color_discrete_sequence=["OrangeRed", "LightSkyBlue"])
fig2 = fig2.update_layout(
        plot_bgcolor="#222222", paper_bgcolor="#222222", font_color="white"
    )
graph2 = dcc.Graph(figure=fig2)

#############################


db_connection3 = "postgresql://postgres:65349115@34.32.37.8/climate"

engine3 = create_engine(db_connection3)


sql_query3 = "SELECT * FROM max_min_humidity"

df_humidity = pd.read_sql(sql_query3, engine3)
df_humidity['country'] = df_humidity['country'].str.replace('"', '')
df_humidity['city'] = df_humidity['city'].str.replace('"', '')


############

fig3 = px.choropleth(
    df_humidity,
    locations="city",
    locationmode='country names',  # Use 'country names' mode to display individual cities
    color="avghumidity",
    color_continuous_scale=px.colors.sequential.Blues,
    labels={'avghumidity': 'Average Humidity'},
)

fig3 = fig3.update_layout(
        plot_bgcolor="#222222", paper_bgcolor="#222222", font_color="white", geo_bgcolor="#222222")
graph3 = dcc.Graph(figure=fig3)
                      
#####################

app =dash.Dash(external_stylesheets=[dbc.themes.DARKLY])
server = app.server

radio= dcc.RadioItems(id="cities",options=['Berlin', 'London', 'Kuala Lumpur'], value="Berlin", 
                      inline=True, style ={'paddingLeft': '30px'})

app.layout = html.Div([html.H1('City Climate Overview', style={'textAlign': 'center', 'color': '#636EFA'}), 
                       html.Div(html.P('Weather insights'), 
                                style={'marginLeft': 50, 'marginRight': 25}),
                       html.Div([html.Div( 
                                          style={'backgroundColor': '#636EFA', 'color': 'white', 
                                                 'width': '900px', 'marginLeft': 'auto', 'marginRight': 'auto'}),
                                 table, radio, graph,  graph2, graph3])
                                             ])
@callback(
    Output(graph, "figure"), 
    Input("countries", "value"))

def update_bar_chart(country): 
    mask = df_countries["country"]==(country)
    fig =px.bar(df_countries[mask], 
             x='date', 
             y='avgtemp_c',  
             color='country',
             color_discrete_map = {'Berlin': '#7FD4C1', 'London': '#8690FF', 'Kuala Lumpur': '#F7C0BB'},
             barmode='group',
             height=300, title = "Berlin vs London & Kuala Lumpur",)
    fig = fig.update_layout(
        plot_bgcolor="#222222", paper_bgcolor="#222222", font_color="white"
    )

    return fig 
if __name__ == "__main__":
    app.run_server(port=8058)


    






