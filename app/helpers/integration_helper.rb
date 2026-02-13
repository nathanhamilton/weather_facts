module IntegrationHelper

  def success?(result)
    result.response.code.to_i == 200
  end

  def success_but_no_data?(result)
    success?(result) && result.body == "[]"
  end
end
