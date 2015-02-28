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

post("温度/湿度を監視はじめます:cop:")

#set alert temp
cold_temp = 20
hot_temp = 28

#set alert hum
high_hum = 75
low_hum = 35

#init status
temp_clean = true
hum_clean = true

loop do
  data = `sudo /home/pi/Adafruit_Python_DHT/examples/AdafruitDHT.py 2302 4`
  data_array = data.split(",")

  if temp_clean
    if data[0].to_i < cold_temp
      #send cool nofity messege
      post(":snowflake:温度が#{cold_temp}度以下になりました")
      temp_clean = false
    elsif data[0].to_i > hot_temp
      #send hot notify message
      post(":sunny:温度が#{hot_temp}度以上になりました")
      temp_clean = false
    else
      temp_clean = true
    end
  end


  if hum_clean
    if data[1].to_i < low_hum
      #send dry nofity messege
      post(":cactus:湿度が#{low_hum}%以下になりました")
      hum_clean = false
    elsif data[1].to_i > high_hum
      #send wet notify message
      post(":droplet:湿度が#{high_hum}%以上になりました")
      hum_clean = false
    else
      hum_clean = true
    end
  end

  sleep(60)

end

