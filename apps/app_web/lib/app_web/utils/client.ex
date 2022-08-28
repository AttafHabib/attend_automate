defmodule AppWeb.Utils.Client do
  use HTTPoison.Base


  def get_user_face(user_id) do
    url = "user/#{user_id}/extract"

    request_url(:get, url)
  end

#  def get_(params) do
#    token = params[:authentication_key]
#    headers = [{"authentication_key", token}]
#    type = params[:request_type]
#    url = process_query(params)
#
#    if(type && url) do
#      request_url(type, url, headers)
#    else
#      {:error, "Invalid query params"}
#    end
#  end

#  def post_(query_params, params) do
#    token = query_params[:authentication_key]
#    headers = [{"authentication_key", token}]
#    type = query_params[:request_type]
#    url = process_query(query_params)
#
#    if(type && url) do
#      request_url(type, url, headers, params)
#    else
#      {:error, "Invalid query params"}
#    end
#  end

#  def delete_(query_params) do
#    token = query_params[:authentication_key]
#    headers = [{"authentication_key", token}]
#    type = query_params[:request_type]
#    url = process_query(query_params)
#
#    if(type && url) do
#      request_url(type, url, headers)
#    else
#      {:error, "Invalid query params"}
#    end
#  end

  def request_url(:get, url) do
    case get(url) do

      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code == 200 ->
        {:ok, body}

      {:ok, %HTTPoison.Response{body: {:error, reason}}} ->
        {:error, reason}

      {:ok, %HTTPoison.Response{status_code: code, body: body}} when (code == 404) ->
        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Api Error: #{reason}"}
    end
  end

#  def request_url(:post, url, headers, body) do
#    case post(url, body, headers) do
##
#      {:ok, %HTTPoison.Response{status_code: code, body: body}} when (code in 200..299) ->
#        body
#
#      {:ok, %HTTPoison.Response{body: {:error, reason}}} ->
#        {:error, reason}
#
#      {:ok, %HTTPoison.Response{body: body}} ->
#        {:ok, "Returned response not in 200. #{body}"}
#
#      {:error, %HTTPoison.Error{reason: reason}} ->
#        {:error, "Api Error: #{reason}"}
#    end
#  end

#  def request_url(:delete, url, headers) do
#    case delete(url, headers) do
#      #
#      {:ok, %HTTPoison.Response{status_code: code, body: body}} when (code in 200..299) ->
#        body
#
#      {:ok, %HTTPoison.Response{body: {:error, reason}}} ->
#        {:error, reason}
#
#      {:ok, %HTTPoison.Response{body: body}} ->
#        {:ok, "Returned response not in 200. #{body}"}
#
#      {:error, %HTTPoison.Error{reason: reason}} ->
#        {:error, "Api Error: #{reason}"}
#    end
#  end

#  defp process_query(params) do
#    url = case params[:query_params][:query] do
#      :get_report_by_id -> r_id = params[:report_id]
#                           r_id && "report/#{r_id}/request" || {:error, "Invalid or no query params"}
#      :get_all_reports -> "reports"
#      :delete_report_by_id -> r_id = params[:report_id]
#                              r_id && "report/#{r_id}/request" || {:error, "Invalid or no query params"}
#      :save_report_request -> "report/request"
#    end
#
#    url = params[:url] <> url
#  end


  #Ovveridden

  defp process_request_url(url) do
  s= "http://127.0.0.1:5000/" <> url
  end

  defp process_response_body(body) do
    cond do
      body |> String.match?(~r|access denied|i) ->  {:error, "Access denied. You may not have permission to view this resource."}
      body == "Internal Server Error" -> {:error, "Internal Server Error"}
      true -> body
    end
  end

#  defp process_request_body(body) when is_binary(body), do: body
#
#  defp process_request_body(body) do
#    body
#    |> Jason.encode!
#  end
#
#  defp process_request_headers(headers) do
#    headers ++ [{"Content-Type", "application/json"}]
#  end
end