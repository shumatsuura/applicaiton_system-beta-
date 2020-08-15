module ApplicationHelper
  #f.objectで@userを取得、.classでモデルであるUserを取得
  #.klassでモデル（Education）を取得、newでEducation.new
  #孫要素のフォームを追加するコード
  def link_to_add_fields(name, form, association)
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    # id = f.object.send(association).length

    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", form: builder)
    end
    link_to(name, '#', class: "add_fields btn btn-primary btn-sm", data: {id: id, fields: fields.gsub("\n", "")})
  end

  #deviseを用いてモーダルでサインアップ
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
