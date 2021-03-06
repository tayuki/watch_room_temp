require 'net/http'
require 'uri'
require 'json'
require 'dotenv'

Dotenv.load

def post(text)
  data = {
    "text" => text
  }
  uri = URI.parse(ENV["REQ_URL"])
  http = Net::HTTP.post_form(uri, {"payload" => data.to_json})
end

def get_data
  data = `sudo /home/pi/Adafruit_Python_DHT/examples/AdafruitDHT.py 2302 4`
  unless data == "Failed to get reading. Try again!"
    data_array = data.split(",")
  end
end

def say(serif)
  command = "~/aquestalkpi/AquesTalkPi #{serif} | aplay"
  system(command)
end


post("温度/湿度を監視はじめます:cop:")
say("温度、湿度を監視始めます")

#set alert temp
cold_temp = 18
hot_temp = 28

#set alert hum
high_hum = 75
low_hum = 30

#init status
temp_clean = true
hum_clean = true


loop do
  data = `sudo /home/pi/Adafruit_Python_DHT/examples/AdafruitDHT.py 2302 4`
  data_array = data.split(",")

  if data_array[0].to_i < cold_temp
    #send cool nofity messege
    if temp_clean
      post(":snowflake:温度が#{cold_temp}度以下になりました")
      say("温度が#{cold_temp}度以下になりました")
    end
    temp_clean = false
  elsif data_array[0].to_i > hot_temp
    #send hot notify message
    if temp_clean
      post(":sunny:温度が#{hot_temp}度以上になりました")
      say("温度が#{hot_temp}度以上になりました")
    end
    temp_clean = false
  else
    temp_clean = true
  end


  if data_array[1].to_i < low_hum
    #send dry nofity messege
    post(":cactus:湿度が#{low_hum}%以下になりました") if hum_clean
    hum_clean = false
  elsif data_array[1].to_i > high_hum
    #send wet notify message
    post(":droplet:湿度が#{high_hum}%以上になりました") if hum_clean
    hum_clean = false
  else
    hum_clean = true
  end

    sleep(360)

end

