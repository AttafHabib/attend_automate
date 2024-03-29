defmodule AppWeb.Utils.Client do
  use HTTPoison.Base


  def get_user_face(user_id, username) do
    url = "user/#{user_id}/#{username}/extract"

    request_url(:get, url)
  end

  def train_model() do
    url = "train_model"
    request_url(:post, url)
  end

  def recognize_faces() do
    url = "recognize_faces"
    request_url(:get, url, [timeout: 20000, rec_timeout: 20000])
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
  def request_url(_, _, options \\ [])
  def request_url(:get, url, options) do
    case get(url, [], [timeout: 50_000, recv_timeout: 50_000]) do

      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code == 200 ->
        {:ok, body}

      {:ok, %HTTPoison.Response{body: {:error, data}}} ->
        {:error, data}

      {:ok, %HTTPoison.Response{status_code: code, body: body}} when (code == 404) ->
        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Api Error: #{reason}"}
    end
  end

  def request_url(:post, url, options) do
    case post(url, options) do

      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code == 200 ->
        body

      {:ok, %HTTPoison.Response{body: {:error, data}}} ->
        {:error, data}

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
    case Jason.decode(body) do
      {:ok, %{"data" => data, "message" => "Image Extracted"}} -> data
      {:ok, %{"data" => data, "message" => "Faces Recognized"}} -> data
      {:ok, %{"data" => data, "message" => "Error"}} -> {:error, data}
      {:error, %Jason.DecodeError{}} -> {:error, "Decoding Error"}
      body -> body
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