defmodule RequestCounterTest do
  use ExUnit.Case
  doctest RequestCounter

  test "Fails on the 11th time" do
    assert 11 == run_until('lumpy')
  end

  test "Fails after 11th time and counts additional tries" do
    assert 11 == run_until('itchy')
    assert 12 == run_until('itchy')
  end

  test "Counts different ip addresses separately" do
    assert 11 == run_until('chewie')
    assert 11 == run_until('han')
  end

  test "Limit can be changed" do
    assert 2 == run_until('luke', limit: 1)
  end

  test "Timeout expires previous buckets" do
    timeout = 10
    assert 2 == run_until('leia', timeout: timeout, limit: 1)
    assert "sall good" == fail_until('leia', timeout: timeout, limit: 1)
  end

  defp run_until(ip_address, opts \\ []) do
    case RequestCounter.check_rate(%{remote_ip: ip_address}, opts)  do
      {:ok, _count}  -> run_until(ip_address, opts)
      {:fail, count} -> count
    end
  end

  defp fail_until(ip_address, opts \\ []) do
    case RequestCounter.check_rate(%{remote_ip: ip_address}, opts)  do
      {:ok, count}  -> count
      {:fail, _count} -> fail_until(ip_address, opts)
    end
  end
end
