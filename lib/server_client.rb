class ServerClient
  attr_reader :name, :connection

  def initialize(connection, player_name)
    @connection = connection
    @name = player_name
  end

  def provide_input(text)
    connection.puts(text)
  end

  def capture_output(delay = 0.1)
    sleep(delay)
    connection.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    ''
  end

  def close
    connection.close if connection
  end
end
