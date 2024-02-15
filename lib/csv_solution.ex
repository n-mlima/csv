defmodule CsvSolution do
  @file_path "./test/fixtures/cities_vazio.csv"
  def read_parse_csv() do
    case File.read(@file_path) do
      {:ok, ""} ->
        IO.puts("Arquivo vazio: #{@file_path}")
        {:error, "Empty File"}

      {:error, :enoent}->
        IO.puts("Arquivo não encontrado: #{@file_path}")
        {:error, "File Not Found"}

      {:ok, content} ->
        case parse_csv(content) do
          {:ok, data} ->
            data

          {:error, reason} ->
            IO.puts("Erro ao analisar o arquivo CSV: #{reason}")
            {:error, reason}
        end


    end
  end

  defp parse_csv(content) do
    lines = String.split(content, "\n")
    headers = String.split(Enum.at(lines, 0), ",")
    data = Enum.map(Enum.drop(lines, 1), fn line ->
      String.split(line, ",")
    end)

    if Enum.all?(data, fn row -> length(row) == length(headers) end) do
      {:ok, Enum.map(data, fn row ->
        Enum.zip(headers, row) |> Map.new
      end)}
    else
      {:error, "Invalid CSV"}
    end
  end
end
