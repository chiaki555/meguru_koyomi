require "google/cloud/storage"
require "stringio"

# ----- GCS 認証 -----
service_account_path = Rails.root.join("tmp/service_account.json")

unless File.exist?(service_account_path)
  puts "GCS credentials not found. Skip GCS attach."
  return
end

storage = Google::Cloud::Storage.new(
  credentials: service_account_path.to_s
)
bucket = storage.bucket "meguru_koyomi"

# ----- GCS アタッチ共通メソッド -----
def attach_gcs_image(record, file_name, gcs_bucket, attachment_name:)
  attachment = record.public_send(attachment_name)
  return if attachment.attached?

  file = gcs_bucket.file(file_name)
  return unless file

  attachment.attach(
    io: StringIO.new(file.download.read),
    filename: File.basename(file_name),
    content_type: "image/jpeg"
  )
end

# --- 季節湯 ---
# サムネイル
{
  "桜湯" => "baths/thumbnails/sakura_yu.jpg"
}.each do |name, file_name|
  bath_template = ::SeasonalBaths::SeasonalBathTemplate.find_by(name: name)
  next unless bath_template

  attach_gcs_image(
    bath_template,
    file_name,
    bucket,
    attachment_name: :bath_thumbnail
  )
end

# アイコン
{
  "桜湯" => "baths/icons/sakura_yu_icon.jpg"
}.each do |name, file_name|
  bath_template = ::SeasonalBaths::SeasonalBathTemplate.find_by(name: name)
  next unless bath_template

  attach_gcs_image(
    bath_template,
    file_name,
    bucket,
    attachment_name: :bath_icons
  )
end

# --- 行事 ---
# サムネイル
{
  "元日" => "events/thumbnails/ganjitsu.jpg"
}.each do |name, file_name|
  event_template = ::EventTemplates::EventTemplate.find_by(name: name)
  next unless event_template

  attach_gcs_image(
    event_template,
    file_name,
    bucket,
    attachment_name: :event_thumbnail
  )
end

# アイコン
{
  "元日" => "events/icons/ganjitsu_icon.jpg"
}.each do |name, file_name|
  event_template = ::EventTemplates::EventTemplate.find_by(name: name)
  next unless event_template

  attach_gcs_image(
    event_template,
    file_name,
    bucket,
    attachment_name: :event_icons
  )
end

# --- 行事固有のおすすめスポット ---
{
  [ "氏神様", "夏越の大祓" ] => "event_spots/images/ujigamisama_nagoshi.jpg"
}.each do |(spot_name, event_name), file_name|
  spot = ::RecommendedSpots::RecommendedSpot.find_by(name: spot_name)
  event_template = ::EventTemplates::EventTemplate.find_by(name: event_name)
  ets = ::EventTemplateSpots::EventTemplateSpot.find_by(
    event_template: event_template,
    recommended_spot: spot
  )
  next unless ets

  attach_gcs_image(
    ets,
    file_name,
    bucket,
    attachment_name: :spot_image
  )
end

# --- 行事食 ---
{
  "御節" => "event_foods/thumbnails/osechi.jpg"
}.each do |name, file_name|
  food = ::EventFoods::EventFood.find_by(name: name)
  next unless food

  attach_gcs_image(
    food,
    file_name,
    bucket,
    attachment_name: :thumbnail
  )
end
