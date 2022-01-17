require 'jwt'

key_file = 'key.txt'
team_id = '83M5ANFM22'
client_id = 'com.progiom.Bynabaa'
key_id = '5HJ6B5GKYK'

ecdsa_key = OpenSSL::PKey::EC.new IO.read key_file

headers = {
'kid' => key_id
}

claims = {
    'iss' => team_id,
    'iat' => Time.now.to_i,
    'exp' => Time.now.to_i + 86400*180,
    'aud' => 'https://appleid.apple.com',
    'sub' => client_id,
}

token = JWT.encode claims, ecdsa_key, 'ES256', headers

puts token