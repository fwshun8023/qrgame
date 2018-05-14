class SecretsController < ApplicationController
  before_action :set_secret, only: [:show, :edit, :update, :destroy]

  # GET /secrets
  def index
    @secrets = Secret.all
  end

  # GET /secrets/1
  def show
    qrcode = RQRCode::QRCode.new(@secret.content)
    @data_list = qrcode.modules
    @unit_size = @data_list.count
    # secret_date为按行密码+按列密码
    @row_secret_data = []
    @column_secret_data = []
    # 按行密码
    @data_list.each do |row|
      key = row.first
      key_count = 0
      row_secret = []
      row.each_with_index do |cell, index|
        if cell == key
          key_count += 1
        else
          # key计数
          row_secret.push([key, key_count.to_s])
          # 新的key计算
          key = cell
          key_count = 1
        end
        if index == row.length - 1
          row_secret.push([key, key_count.to_s])
        end
      end

      @row_secret_data.push(row_secret)
    end

    @data_list.transpose.each do |column|
      key = column.first
      key_count = 0
      column_secret = []
      column.each_with_index do |cell, index|
        if cell == key
          key_count += 1
        else
          # key计数
          column_secret.push([key, key_count.to_s])
          # 新的key计算
          key = cell
          key_count = 1
        end
        if index == column.length - 1
          column_secret.push([key, key_count.to_s])
        end
      end

      @column_secret_data.push(column_secret)
    end
  end

  # GET /secrets/new
  def new
    @secret = Secret.new
  end

  # GET /secrets/1/edit
  def edit
    qrcode = RQRCode::QRCode.new(@secret.content)
    @data_list = qrcode.modules
    @unit_size = @data_list.count
    # secret_date为按行密码+按列密码
    @row_secret_data = []
    @column_secret_data = []
    # 按行密码
    @data_list.each do |row|
      key = row.first
      key_count = 0
      row_secret = []
      row.each_with_index do |cell, index|
        if cell == key
          key_count += 1
        else
          # key计数
          row_secret.push([key, key_count.to_s])
          # 新的key计算
          key = cell
          key_count = 1
        end
        if index == row.length - 1
          row_secret.push([key, key_count.to_s])
        end
      end

      @row_secret_data.push(row_secret)
    end

    @data_list.transpose.each do |column|
      key = column.first
      key_count = 0
      column_secret = []
      column.each_with_index do |cell, index|
        if cell == key
          key_count += 1
        else
          # key计数
          column_secret.push([key, key_count.to_s])
          # 新的key计算
          key = cell
          key_count = 1
        end
        if index == column.length - 1
          column_secret.push([key, key_count.to_s])
        end
      end

      @column_secret_data.push(column_secret)
    end
  end

  # POST /secrets
  def create
    @secret = Secret.new(secret_params)

    if @secret.save
      redirect_to @secret, notice: 'Secret was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /secrets/1
  def update
    if @secret.update(secret_params)
      redirect_to @secret, notice: 'Secret was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /secrets/1
  def destroy
    @secret.destroy
    redirect_to secrets_url, notice: 'Secret was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_secret
      @secret = Secret.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def secret_params
      params.require(:secret).permit(:content)
    end
end
