defmodule TwitterPhxWeb.ChannelFile do
    use Phoenix.Channel
    alias TwitterServerFrontEnd
    :observer.start
  
    def join("twitter:interface", _payload, socket) do
      {:ok, socket}
    end
  
    def handle_in("register", payload, socket) do 
      IO.puts "in the register event"         
      IO.inspect payload
      username = Map.get(payload, "username")
      password = Map.get(payload, "password")
      case GenServer.call(TwitterPhx.TwitterServer, {:register, username, password, "userpid"}) do
        {:ok, msg} ->
          {:reply, {:ok, msg}, socket}
        {:error, msg} ->
          {:reply, {:ok, msg}, socket}
      end      
      {:noreply, socket}
    end

    def handle_in("login", payload, socket) do
      username = Map.get(payload, "name")
      password = Map.get(payload, "password")
      case GenServer.call(TwitterPhx.TwitterServer, {:login, username, password,"client_pid"}) do
        {:ok, msg} ->
          {:reply, {:ok, msg}, socket}
        {:error, msg} ->
          {:reply, {:ok, msg}, socket}
      end      
      {:noreply, socket}
    end
    
    def handle_in("logout", payload, socket) do
      username = Map.get(payload, "name")      
      case GenServer.call(TwitterPhx.TwitterServer, {:logout, username,"client_pid"}) do
        {:ok, msg} ->
          {:reply, {:ok, msg}, socket}
        {:error, msg} ->
          {:reply, {:ok, msg}, socket}
      end
      {:noreply, socket}
    end

    def handle_in("follow", payload, socket) do
      subscriber = Map.get(payload, "following")
      subscribed_to = Map.get(payload, "follower")      
      case GenServer.call(TwitterPhx.TwitterServer, {:subscribe_user, subscriber, subscribed_to}) do
        {:ok, msg} ->
          {:reply, {:ok, msg}, socket}
        {:error, msg} ->
          {:reply, {:ok, msg}, socket}
      end
      {:noreply, socket}
    end

    def handle_in("send_tweet", payload, socket) do
      username = Map.get(payload, "name")
      tweet = Map.get(payload, "tweet")      
      case GenServer.cast(TwitterPhx.TwitterServer, {:send_tweet, username, tweet}) do
        {:ok, msg} ->
          {:reply, {:ok, msg}, socket}
        {:error, msg} ->
          {:reply, {:ok, msg}, socket}
      end
      {:noreply, socket}
    end       

    #not sure about this
    def handle_in("send_retweet", payload, socket) do
      username1 = Map.get(payload, "username1")
      username2 = Map.get(payload, "username2")
      tweet = Map.get(payload, "tweet")            
      case GenServer.cast(TwitterPhx.TwitterServer, {:retweet, username1, username2, tweet}) do
        {:ok, msg} ->
          {:reply, {:ok, msg}, socket}
        {:error, msg} ->
          {:reply, {:ok, msg}, socket}
      end
      {:noreply, socket}
    end    

    def handle_in("search_hashtag", payload, socket) do      
      hashtag = Map.get(payload, "hashtag")      
      response =  GenServer.call(TwitterPhx.TwitterServer, {:search_hashtag, hashtag})
      msg = "Search result for hashtag #{hashtag} : #{response}"
      push  socket, "receive_response", %{"message" => msg}
      {:noreply, socket}
    end  

    def handle_in("search_username", payload, socket) do
      username = Map.get(payload, "username")      
      response =  GenServer.call(TwitterPhx.TwitterServer, {:search_user, username})
      msg = "Search result for username #{username} : #{response}"
      push  socket, "receive_response", %{"message" => msg}
      {:noreply, socket}
    end  

    def handle_in("receive_tweet", payload, socket) do      
      {:noreply, socket}
    end

  end