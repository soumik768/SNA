turtles-own
[
  infected?           ;; if true, the turtle is infectious
  resistant?          ;; if true, the turtle can't be infected
  viral-load          ;;
   ;; avg number of nodes connected to
  virus-check-timer   ;; number of ticks since this turtle's last virus-check
  MPC                 ;; the proportion of income to spend on essential goods (MPC)
  income              ;; Initial value of income to be 1000, 5000, 10000, 50000 for four different economic groups
  savings             ;; Initial value of savings to be 0
]


breed [canaries canary]
breed [snakes snake]

to setup
  clear-all
  setup-nodes
  setup-spatially-clustered-network
  ;;ask n-of initial-outbreak-size turtles
   ;; [ become-infected ]
  ask links [ set color white ]
  reset-ticks
end


to setup-nodes

  set-default-shape snakes "square"
  create-snakes (number-of-nodes)/(3)
  [
    ; for visual reasons, we don't put any nodes *too* close to the edges
    setxy (random-xcor * 0.95) (random-ycor * 0.95)
    ;; ### become-susceptible
    set virus-check-timer random virus-check-frequency
    set color red
    set income 1000
    set MPC 0.99
    set savings 0
  ]

  set-default-shape canaries "triangle"
  create-canaries (number-of-nodes)/(3)
  [
    ; for visual reasons, we don't put any nodes *too* close to the edges
    setxy (random-xcor * 0.95) (random-ycor * 0.95)
    ;; ### become-susceptible
    set virus-check-timer random virus-check-frequency
    set color blue
    set income 5000
    set MPC 0.75
    set savings 0
  ]

  set-default-shape turtles "circle"
  create-turtles (number-of-nodes)/(3)
  [
    ; for visual reasons, we don't put any nodes *too* close to the edges
    setxy (random-xcor * 0.95) (random-ycor * 0.95)
    ;; ### become-susceptible
    set virus-check-timer random virus-check-frequency
    set color green
    set income 10000
    set MPC 0.65
    set savings 0
  ]
end


to setup-spatially-clustered-network
  let num-links (average-node-degree * number-of-nodes) / (stricktness-of-lockdown + 1)
  while [count links < num-links ]
  [
    ask one-of turtles
    [
      let choice (min-one-of (other turtles with [not link-neighbor? myself])
                   [distance myself])
      if choice != nobody [ create-link-with choice ]
    ]
  ]
  ; make the network look a little prettier
  repeat 10
  [
    layout-spring turtles links 0.3 (world-width / (sqrt number-of-nodes)) 1
  ]
end
