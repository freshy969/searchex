defmodule Searchex.Command.Build.Catalog.Fs do
  @moduledoc false

  defstruct rawdata:           ""                               ,
            input_filename:    ""                               ,
            docsep_positions:  []                               ,
            docsep_offsets:    []                               


  def generate_filescan(catalog, filename) do
    %Searchex.Command.Build.Catalog.Fs{input_filename: filename}
    |> read_rawdata
    |> gen_docsep_positions(catalog)
    |> gen_docsep_offsets
  end
  
  defp read_rawdata(scan) do
    rawdata = File.stream!(scan.input_filename, [], scan.params.max_file_kb * 1024) |> Enum.at(0)
    %Searchex.Command.Build.Catalog.Fs{scan | rawdata: rawdata}
  end

  defp gen_docsep_positions(scan, catalog) do
    positions = catalog.params.docsep
                |> Regex.scan(scan.rawdata, return: :index )
                |> Enum.map(fn(x) -> [{beg, fin} | _tail] = x; beg + fin end)
    %Searchex.Command.Build.Catalog.Fs{scan | docsep_positions: positions}
  end

  defp gen_docsep_offsets(scan) do
    offsets = scan.docsep_positions
              |> gen_offsets([])
    %Searchex.Command.Build.Catalog.Fs{scan | docsep_offsets: offsets}
  end

  defp gen_offsets([], list), do: list
  defp gen_offsets([head|tail], list) do
    gen_offsets(tail, list ++ [head - Enum.sum(list)])
  end
end
