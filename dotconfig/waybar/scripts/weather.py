#!/usr/bin/env python3
## vim: set fenc=utf-8 ts=4 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## weather.py
## by Andy3153
##
## Gets IP location and uses it to show weather info from Open-Meteo to stdout
## or to Waybar
##
## This could've probably been quite shorter, since Open-Meteo provides a Python
## lib but this was my first attempt at using APIs and I wanted my fun. Bonus:
## not many libraries, only requires python-requests, time and argparse.
##

# {{{ Imports
import requests
import time
import argparse
# }}}

# {{{ Variables
# {{{ Weather messages
# Read about WMO Weather interpretation codes (WW)
# https://open-meteo.com/en/docs
# (end of webpage)

weatherMessage = {
    # {{{ Long
    "long": {
        0:  "Clear sky",

        1:  "Mainly clear",
        2:  "Partly cloudy",
        3:  "Cloudy",

        45: "Fog",
        48: "Depositing rime fog",

        51: "Light drizzle",
        53: "Moderate drizzle",
        55: "Dense drizzle",

        56: "Light freezing drizzle",
        57: "Dense freezing drizzle",

        61: "Slight rain",
        63: "Moderate rain",
        65: "Heavy rain",

        66: "Slight freezing rain",
        67: "Heavy freezing rain",

        71: "Slight snow fall",
        73: "Moderate snow fall",
        75: "Heavy snow fall",

        77: "Snow grains",

        80: "Slight rain showers",
        81: "Moderate rain showers",
        82: "Violent rain showers",

        85: "Slight snow showers",
        86: "Heavy snow showers",

        95: "Thunderstorm",

        96: "Slight thunderstorm",
        99: "Heavy thunderstorm",
    },
    # }}}

    # {{{ Short
    "short": {
        0:  "Clear",

        1:  "Clear",
        2:  "Cloudy",
        3:  "Cloudy",

        45: "Fog",
        48: "Fog",

        51: "Drizzle",
        53: "Drizzle",
        55: "Drizzle",

        56: "Drizzle",
        57: "Drizzle",

        61: "Rain",
        63: "Rain",
        65: "Rain",

        66: "Rain",
        67: "Rain",

        71: "Snow",
        73: "Snow",
        75: "Snow",

        77: "Snow",

        80: "Rain",
        81: "Rain",
        82: "Rain",

        85: "Snow",
        86: "Snow",

        95: "Storm",

        96: "Storm",
        99: "Storm",
    },
    # }}}
}
# }}}

# {{{ Weather icons
weatherIcon = {
    # {{{ Day icons
    1: {
        0:  " ",

        1:  " ",
        2:  " ",
        3:  " ",

        45: " ",
        48: " ",

        51: " ",
        53: " ",
        55: " ",

        56: " ",
        57: " ",

        61: " ",
        63: " ",
        65: " ",

        66: " ",
        67: " ",

        71: " ",
        73: " ",
        75: " ",

        77: " ",

        80: " ",
        81: " ",
        82: " ",

        85: " ",
        86: " ",

        95: " ",

        96: " ",
        99: " ",
    },
    # }}}

    # {{{ Night icons
    0: {
        0:  " ",

        1:  " ",
        2:  " ",
        3:  " ",

        45: " ",
        48: " ",

        51: " ",
        53: " ",
        55: " ",

        56: " ",
        57: " ",

        61: " ",
        63: " ",
        65: " ",

        66: " ",
        67: " ",

        71: " ",
        73: " ",
        75: " ",

        77: " ",

        80: " ",
        81: " ",
        82: " ",

        85: " ",
        86: " ",

        95: " ",

        96: " ",
        99: " ",
    },
    # }}}

    # {{{ Misc icons
    "misc": {
        "degree":     "°",
        "celsius":    "°C",
        "fahrenheit": "°F",
    }
    # }}}
}
# }}}
# }}}

# {{{ Functions
# {{{ Fetch IP details
def IP():
    link     = 'http://ip-api.com/json/?fields=lat,lon,city'
    response = requests.get(link).json()

    locationData = {
        "latitude":  response.get("lat"),
        "longitude": response.get("lon"),
        "city":      response.get("city"),
    }

    return locationData
# }}}

# {{{ Fetch weather data
# https://open-meteo.com/en/docs
# (play with the checkboxes to figure things out)

def weather(latitude, longitude):
    # {{{ Current weather data
    current   = ('temperature_2m,'
                 'apparent_temperature,'
                 'relative_humidity_2m,'
                 'precipitation,'
                 'wind_speed_10m,'
                 'wind_direction_10m,'
                 'weather_code,'
                 'is_day,')
    # }}}
    # {{{ Link
    link      = ('https://api.open-meteo.com/v1/forecast?timezone=auto&'
                 'latitude='           + latitude               + '&'
                 'longitude='          + longitude              + '&'
                 'temperature_unit='   + units["temperature"]   + '&'
                 'wind_speed_unit='    + units["wind_speed"]    + '&'
                 'precipitation_unit=' + units["precipitation"] + '&'
                 'timeformat='         + units["time"]          + '&'
                 'current='            + current                + '&')
    # }}}
    # {{{ Collect request responses
    response         = requests.get(link).json()
    response_current = response.get("current")
    # }}}
    # {{{ Organize data from response
    weatherData = {
        "temp":           response_current.get("temperature_2m"),
        "feelslike_temp": response_current.get("apparent_temperature"),
        "humidity":       response_current.get("relative_humidity_2m"),
        "precipitation":  response_current.get("precipitation"),
        "wind_speed":     response_current.get("wind_speed_10m"),
        "wind_direction": response_current.get("wind_direction_10m"),
        "weather_code":   response_current.get("weather_code"),
        "is_day":         response_current.get("is_day"),
    }
    # }}}

    return weatherData
# }}}
# }}}

# {{{ Main
# {{{ Parse command-line arguments
parser = argparse.ArgumentParser()

parser.add_argument("-o", "--output", type=str, required=False,
                    dest="output",
                    choices=['stdout', 'waybar'],
                    default='stdout',
                    help="Output made for stdout or for parsing by Waybar"
                    )

parser.add_argument("-t", "--temp-unit", type=str, required=False,
                    dest="temp",
                    choices=['celsius', 'fahrenheit'],
                    default='celsius',
                    help="Change the unit used for temperature"
                    )

parser.add_argument("-w", "--wind-unit", type=str, required=False,
                    dest="wind",
                    choices=['kmh', 'ms', 'mph', 'kn'],
                    default='kmh',
                    help="Change the unit used for wind speed"
                    )

parser.add_argument("-p", "--precipitation-unit", type=str, required=False,
                    dest="precipitation",
                    choices=['mm', 'inch'],
                    default='mm',
                    help="Change the unit used for precipitation"
                    )

parser.add_argument("-T", "--time-unit", type=str, required=False,
                    dest="time",
                    choices=['iso8601', 'unixtime'],
                    default='iso8601',
                    help="Change the unit used for time"
                    )

args = parser.parse_args()
# }}}

# {{{ Units from command-line arguments
units = {
    "temperature":   args.temp,
    "wind_speed":    args.wind,
    "precipitation": args.precipitation,
    "time":          args.time,
}
# }}}

# {{{ Fetch weather info
city = ""
internetConnection = False
start              = time.time()

# Check for internet connection every 5 seconds
while not(internetConnection):
    try:
        # Get latitude and longitude
        #
        # You can replace coordiantes manually if you don't wish to use IP geolocation:
        #
        # latitude  = 29.97916
        # longitude = 31.13421
        #
        latitude  = IP()["latitude"]
        longitude = IP()["longitude"]
        city      = IP()["city"]

        # Store weather info
        weather = weather(str(latitude), str(longitude))
    except requests.ConnectionError:
        time.sleep(5)

        end = time.time()
        if end - start > 1752: quit() # quit right before waybar refreshes the script
    else:
        internetConnection = True
# }}}

# {{{ Data to output to Waybar
# {{{ Variables
temp                 = str(round(weather["temp"])) + weatherIcon["misc"]["degree"]
temp_degree          = str(weather["temp"]) + weatherIcon["misc"][units["temperature"]]
tempFeelsLike_degree = str(weather["feelslike_temp"]) + weatherIcon["misc"][units["temperature"]]

isDay                = weather["is_day"]
weatherCode          = weather["weather_code"]

icon                 = weatherIcon[isDay][weatherCode]
shortMsg             = weatherMessage["short"][weatherCode]
longMsg              = weatherMessage["long"][weatherCode]
# }}}

# {{{ Output for stdout
if args.output == "stdout":
    output = icon          + '\n' +\
             temp_degree   + '\n' +\
             city          + '\n' +\
             '\n'                 +\
             longMsg       + '\n' +\
             'Feels like ' + tempFeelsLike_degree
# }}}

# {{{ Output for Waybar
if args.output == "waybar":
    waybarText    = icon + " " + temp + " " + shortMsg
    waybarClass   = shortMsg.lower()

    waybarTooltip = ('<span size=\'xx-large\'>' + icon                 + '</span>'  + '\\n'
                     '<span size=\'xx-large\'>' + temp_degree          + '</span>'  + '\\n'
                     '<big>'                    + city                 + '</big>'   + '\\n'
                     '\\n'
                     '<big>'                    + longMsg              + '</big>'   + '\\n'
                     'Feels like '              + tempFeelsLike_degree
                     )

    output = ('{'
                    '"text": "'    + waybarText +    '", '
                    '"tooltip": "' + waybarTooltip + '", '
                    '"class": "'   + waybarClass +   '",'
                    '}'
                    )
# }}}

print(output)
# }}}
# }}}
