defmodule TwitterPhxWeb.ChannelFile do
    use Phoenix.Channel
    alias TwitterServerFrontEnd
  
    def join("twitter:interface", _payload, socket) do
      {:ok, socket}
    end
  
    def handle_in("register", payload, socket) do 
      username = Map.get(payload, "username")
      password = Map.get(payload, "password")
      map = %{}
      case IO.inspect GenServer.call(TwitterPhx.TwitterServer, {:register, username, password}) do
        {:ok, msg} ->
          map = Map.put(map, :reply, :ok)
          map = Map.put(map, :message, msg)
          push socket, "register", map
          {:reply, {:ok, msg}, socket}
        {:error, msg} ->
          map = Map.put(map, :reply, :error)
          map = Map.put(map, :message, msg)
          push socket, "register",  map
          {:reply, {:error, msg}, socket}
      end      
      {:noreply, socket}
    end

    def handle_in("login", payload, socket) do
      username = Map.get(payload, "username")
      password = Map.get(payload, "password")
      map = %{}
      case IO.inspect GenServer.call(TwitterPhx.TwitterServer, {:login, username, password, socket}) do
        {:ok, msg} ->
          map = Map.put(map, :reply, :ok)
          map = Map.put(map, :message, msg)
          push socket, "login", map
          {:reply, {:ok, msg}, socket}
        {:error, msg} ->
          map = Map.put(map, :reply, :error)
          map = Map.put(map, :message, msg)
          push socket, "login",  map
          {:reply, {:error, msg}, socket}
      end      
      {:noreply, socket}
    end
    
    def handle_in("logout", payload, socket) do
      username = Map.get(payload, "username")      
      case IO.inspect GenServer.call(TwitterPhx.TwitterServer, {:logout, username,"client_pid"}) do
        {:ok, msg} ->
          {:reply, {:ok, msg}, socket}
        {:error, msg} ->
          {:reply, {:error, msg}, socket}
      end
      {:noreply, socket}
    end

    def handle_in("deleteAccount", payload, socket) do
      IO.inspect username = Map.get(payload, "username")
      IO.inspect password = Map.get(payload, "password")
      case GenServer.call(TwitterPhx.TwitterServer, {:delete_account, username}) do
        {:ok, msg} ->
          IO.inspect msg
          {:reply, {:ok, msg}, socket}
        {:error, msg} ->
          IO.inspect msg
          {:reply, {:ok, msg}, socket}
      end      
      {:noreply, socket}
    end

    def handle_in("subscribe", payload, socket) do
      IO.inspect payload
      subscriber = Map.get(payload, "subscriber")
      subscribed_to = Map.get(payload, "subscribe_to")      
      case IO.inspect GenServer.call(TwitterPhx.TwitterServer, {:subscribe_user, subscriber, subscribed_to}) do
        {:ok, msg} ->
          IO.inspect msg
          {:reply, {:ok, msg}, socket}
        {:error, msg} ->
          IO.inspect msg
          {:reply, {:ok, msg}, socket}
      end      
      {:noreply, socket}
    end
    
    def handle_in("send_tweet", payload, socket) do
      username = Map.get(payload, "username")
      tweet = Map.get(payload, "userTweet")
      case GenServer.call(TwitterPhx.TwitterServer, {:send_tweet, username, tweet}) do
        {:ok, msg} ->
          IO.inspect msg
          {:reply, {:ok, msg}, socket}
        {:error, msg} ->
          IO.inspect msg
          {:reply, {:ok, msg}, socket}
      end      
      {:noreply, socket}
    end

    def handle_in("send_retweet", payload, socket) do
      orignalTweeter = Map.get(payload, "originalTweetSender")
      retweeter = Map.get(payload, "reTweeter")
      tweet = Map.get(payload, "tweet")            
      case IO.inspect GenServer.cast(TwitterPhx.TwitterServer, {:retweet, orignalTweeter, retweeter, tweet}) do
        {:ok, msg} ->
          {:reply, {:ok, msg}, socket}
        {:error, msg} ->
          {:reply, {:error, msg}, socket}
      end
      {:noreply, socket}
    end    
    
    def handle_in("search_username", payload, socket) do
      username = Map.get(payload, "username")      
      result =  GenServer.call(TwitterPhx.TwitterServer, {:searchuser, username})
      msg = "Search result for #{username} : "
      push  socket, "receive_response", %{"message" => msg, "result" => result}
      {:noreply, socket}
    end   

    def handle_in("search_hashtag", payload, socket) do      
      hashtag = Map.get(payload, "hashy")      
      result =  GenServer.call(TwitterPhx.TwitterServer, {:searchhashtag, hashtag})
      msg = "Search result for #{hashtag} : "
      push  socket, "receive_response", %{"message" => msg, "result" => result}
      {:noreply, socket}
    end  

    def handle_in("receive_tweet", payload, socket) do      
      {:noreply, socket}
    end

  end