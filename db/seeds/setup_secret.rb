require "google/cloud/secret_manager"
require "fileutils"

return unless ENV["ON_RENDER"] == "true"

FileUtils.mkdir_p("tmp") unless Dir.exist?("tmp")

# Secret Manager クライアントを作成
client = Google::Cloud::SecretManager.secret_manager_service

# シークレットのフルネームを指定
secret_name = "projects/meguru-koyomi/secrets/meguru_koyomi_service_account_json/versions/latest"

# シークレットを取得
response = client.access_secret_version name: secret_name
service_account_json = response.payload.data

# JSON を一時ファイルに書き出す
File.write("tmp/service_account.json", service_account_json)

# 環境変数に設定
ENV["GOOGLE_APPLICATION_CREDENTIALS"] = File.expand_path("tmp/service_account.json")
