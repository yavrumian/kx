## kx: Easy shortcat for kubectl exec

This Bash function simplifies running `kubectl exec` commands within pods managed by Kubernetes. It now includes support for specifying a namespace with the `-n` flag.

### Functionality

 1.   Lists available pods within a specified namespace using `kubectl get pods`.
 2.   Accepts zero, one or two arguments(`-n \<namespace>` is considered a flag, not an argument):
    --  **No arguments:** Prompts for a pod to select and an additional command to run within it.
    --   **One argument (command):** Prompts for a pod to select and runs the given command within it
    --   **Two arguments (pod name, command):** Runs the given command in the given pod
 3.   Supports specifying a namespace using the `-n` flag followed by the desired namespace name(*it should be specified at **the end** of the command*).
### Setup
 1. **Cool one-liner:**
 
 ````
    curl -fsSL https://github.com/yavrumian/kx/raw/master/setup.sh | sh
    
````
2. **Source the function**

```
source /path/to/kx.sh  # Replace with the actual path to the script

```
### Usage

1.  **No arguments (interactive):**

Bash

```
kx  # Select a pod and provide a command to run.
kx -n <namespace> # Select a pod from the specified namespace and provide a command to run.

```

2.  **One argument (command):**

Bash

```
kx <command>  # Select a pod where the specified command will be executed
kx <command> -n <namespace>  # Select a pod from the specified namespace where the specified command will be executed

```

3.  **Two arguments (pod name, command):**

Bash

```
kx <pod> <command>  # The specified command will be executed in the specified pod
kx <pod> <command> -n <namespace>  # The specified command will be executed in the specified pod from the specified namespace

```


### Example

1. **Running the chosen command within the chosen pod in the `prod` namespace:**

Bash

```
kx -n prod 
# Choose your pod
# Enter the command

```

2. **Running `echo` command within the chosen pod in the default namespace:**

Bash

```
kx "echo ./app/trace.log" 
# Choose your pod

```

3. **Running the `sh` command within pod "my-pod" in the "dev" namespace( ):**

Bash
```
kx -n dev my-pod
# Enter your desired kx command here (e.g., .z.q)

```

 - `kx` uses `-it` flags to run `kubectl exec` by default, so the above command will open a shell session in the pod

### Requirements

-   `kubectl`: Kubernetes command-line tool
-   `fzf`: Fuzzy finder tool ([https://github.com/topics/fzf](https://github.com/topics/fzf))
- `curl`: Command-line tool for transferring data using various network protocols (Only needed when the setup.sh or the one liner is used) ([https://curl.se](https://curl.se))

### Notes

-   The `fzf` options (`--height 90%`,  `--reverse`,  `--prompt="Select a pod: "`) can be customized in the script itself.
- `kx`  uses  `-it`  flags to run  `kubectl exec`  by default.
