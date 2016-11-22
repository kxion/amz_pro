Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless Rails.env.production?
  provider :amazon,
    'amzn1.application-oa2-client.c82ce07ca4c749bd94fbfa23472dceb6',
    '327ecdd009170c66d46f776d3ebe518e72aedd6e38b0905df1167c4d7edf9d3a'
end
