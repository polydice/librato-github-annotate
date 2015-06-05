worker_processes 3 # amount of rainbow workers to spin up
timeout 15         # restarts workers that hang for 30 seconds
preload_app true   # reduce mem footprint

Rainbows! do
  use :EventMachine
end
