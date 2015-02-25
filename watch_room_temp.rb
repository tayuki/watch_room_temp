require 'slack'

Slack.configure do |config|
  config.token = 'T02EZ2BLN/B03PKBEL5/APPRNzm8VGD2cvOBAytyZPOi'
end

Slack.chat_postMessage(text: '‰·“xŠÄŽ‹‚ð‚Í‚¶‚Ü‚ß‚·:cop:', channel: 'general')

temp_clean = true
hum_clean = true

loop do
  data = `sudo /home/pi/Adafruit_Python_DHT/examples/AdafruitDHT.py 2302 4`
  data_array = data.split(",")

  if temp_clean
    if data[0].to_i < 20
      #send cool nofity messege
      temp_clean = false
    elsif data[0].to_i > 28
      #send hot notify message
      temp_clean = false
    else
      temp_clean = true
    end
  end


  if hum_clean
    if data[1].to_i < 35
      #send dry nofity messege
      hum_clean = false
    elsif data[1].to_i > 70
      #send wet notify message
      hum_clean = false
    else
      hum_clean = true
    end
  end

  sleep(60)

end

