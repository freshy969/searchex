defmodule Util.Ext.FileTest do
  use ExUnit.Case

  alias Util.Ext.File
  
  describe "#ls_r" do
    test "no options" do
      results = File.ls_r
      assert is_list(results)
      assert length(results) == 1000
    end

    test "limit with options" do
      opts = %{depth: 2, types: ~w(md), skips: ~w(^\\..+ ^\_ deps)}
      results = File.ls_r ".", opts
      assert length(results) == 3
    end
  end
end
