class Racer
  include ActiveModel::Model

  attr_accessor :id, :number, :first_name, :last_name, :group, :gender, :secs

  def initialize(params={})
    @id = params[:_id].nil? ? params[:id] : params[:_id].to_s
    @number = params[:number].to_i
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @gender = params[:gender]
    @group = params[:group]
    @secs = params[:secs].to_i
  end

  def persisted?
    !@id.nil?
  end

  def created_at
    nil
  end

  def updated_at
    nil
  end

  def self.paginate params
    page = (params[:page] ||= 1).to_i
    limit = (params[:per_page] ||= 30).to_i
    offset = (page - 1) * limit
    sort = params[:sort] ||= {:number => 1}
    racers = []
    all({}, sort, offset, limit).each do |racer|
      racers << Racer.new(racer)
    end
    total = all({}, sort, 0, 1).count
    WillPaginate::Collection.create(page, limit, total) do |pager|
      pager.replace(racers)
    end
  end

  def self.mongo_client
    Mongoid::Clients.default
  end

  def self.collection
    self.mongo_client['racers']
  end

  def self.find id
    result = collection.find(_id: BSON::ObjectId.from_string(id)).first
    return result.nil? ? nil : Racer.new(result)
  end

  def self.all(prototype = {}, sort = {:number => 1}, offset = 0, limit = nil)
    tmp = {}
    sort.each do |k, v|
      tmp[k] = v
    end
    sort = tmp
    # prototype=prototype.symbolize_keys.slice(:city, :state) if !prototype.nil?
    Rails.logger.debug {"getting all racers, prototype=#{prototype}, sort=#{sort}, offset=#{offset}, limit=#{limit}"}

    result = collection.find(prototype).projection({_id: true, number: true, first_name: true, last_name: true, gender: true, group: true, secs: true}).sort(sort).skip(offset)
    result = result.limit(limit) if !limit.nil?
    return result
  end

  def save
    result = self.class.collection.insert_one(_id: @id, number: @number, first_name: @first_name, last_name: @last_name, gender: @gender, secs: @secs, group: @group)
    @id = result.inserted_id
  end

  def update updates
    @number = updates[:number].to_i
    @first_name = updates[:first_name]
    @last_name = updates[:last_name]
    @gender = updates[:gender]
    @group = updates[:group]
    @secs = updates[:secs].to_i
    updates.slice!(:first_name, :last_name, :number, :gender, :group, :secs) if !updates.nil?
    self.class.collection.find(_id: id_).update_one(updates)
  end

  def destroy
    self.class.collection.find(_id: id_).delete_one
  end

  private
    def id_
      BSON::ObjectId.from_string(@id)
    end
end