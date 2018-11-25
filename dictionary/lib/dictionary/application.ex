defmodule Dictionary.Application do
    
    use Application

    def start(_, _) do
        import Supervisor.Spec

        children = [
            worker(Dictionary.WordList, [])
        ]

        options = [
            name: Dictionary.Supervisor,
            strategy: :one_for_one,
        ]

        Supervisor.start_link(children, options)
    end
    
end