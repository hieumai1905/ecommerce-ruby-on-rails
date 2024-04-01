# seed data for account administration
Account.create!(name: "Example User",
                email: "example@railstutorial.org",
                password: "foobar",
                password_confirmation: "foobar",
                is_admin: true,
                is_active: true)

# seed data for account
10.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@gmail.com"
  is_active = Faker::Boolean.boolean
  phone = Faker::PhoneNumber.phone_number
  password = "password"
  account = Account.create!(
    name: name,
    email: email,
    phone: phone,
    is_active: is_active,
    password: password,
    password_confirmation: password
  )

  # Seed data for Bill bills
  3.times do
    bill = account.bills.create!(
      billing_date: Faker::Time.between(from: 1.month.ago, to: Date.today),
      amount: Faker::Commerce.price,
      payment_method: Faker::Commerce.product_name,
      update_at: Faker::Time.between(from: 1.month.ago, to: Date.today),
      status: Faker::Boolean.boolean,
      description: Faker::Lorem.paragraph
    )

    # Seed data for Evaluation
    Evaluation.create!(
      content: Faker::Lorem.sentence,
      comment_at: Faker::Time.between(from: 1.month.ago, to: Date.today),
      update_at: Faker::Time.between(from: 1.month.ago, to: Date.today),
      account_id: account.id,
      bill_id: bill.id
    )
  end
end

# Seed data for product
10.times do
  product = Product.create(
    product_name: Faker::Commerce.product_name,
    status: Faker::Boolean.boolean,
    description: Faker::Lorem.paragraph,
    category: Faker::Commerce.department,
    brand: Faker::Company.name
  )

  # Seed data for product_details
  5.times do
    product.product_details.create!(
      price: Faker::Commerce.price,
      quantity: Faker::Number.between(from: 1, to: 100),
      color: Faker::Color.color_name,
      size: Faker::Number.between(from: 1, to: 10),
    )
  end

  # Seed data for product_photos
  5.times do
    product.product_photos.create(
      photo_path: Faker::Internet.url
    )
  end
end

# seed data for banner
10.times do |n|
  description = Faker::Lorem.paragraph
  photo_path = Faker::LoremPixel.image
  start_at = Faker::Date.between(from: 2.days.ago, to: Date.today)
  finish_at = Faker::Date.between(from: Date.today, to: 2.days.from_now)
  Banner.create!(description: description,
                 photo_path: photo_path,
                 start_at: start_at,
                 finish_at: finish_at)
end
