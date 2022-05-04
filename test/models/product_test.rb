require "test_helper"

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  test "product attributes must not be empty" do
    product = Product.new
  assert product.invalid?
  assert product.errors[:title].any?
  assert product.errors[:description].any?
  assert product.errors[:price].any?
  assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "My book Title",
      description: "Hello",
      image_url: "zzz.pjg")
    product.price=-1
    assert product.invalid?
    assert_equal ["must be greater than or equal 0.01"],product.errors[:price]

product.price=0
assert product.invalid?
assert_equal ["must be greater than or equal 0.01"],product.errors[:price]

product.price=1
assert product.valid?
  end

  def new_product(image_url) Product.new(title: "My Book Title",
    description: "yyy", price: 1, image_url: image_url)
  end

  test "image url" do
    ok =%W{fred.gif fred.jpg fre.png FRE.JPG FRED.Jpg http://a.b.c/z/x/y/fred.gif }
    bad =%W{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |image_url|
      assert new_product(image_url).valid?
        "#{image_url} shouldn't be valid"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?
      "#{image_url} shouldn't be valid"
    end
  end

  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html {redirect_to @product,
          notice: 'Product was successfully created'}
      else
        puts @product.errors.full_messages
        format.html { render :new}
        format.json { render json: @product.errors,
        status: :unprocessable_entity}
      end
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy",
                        price: 1,
                      image_url: "fred.gif")

    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

  test "product is not valid without a unique title - i18n" do product = Product.new(title: products(:ruby).title,
    description: "yyy", price: 1, image_url: "fred.gif")
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')],
                  product.errors[:title]
  end
  
end
