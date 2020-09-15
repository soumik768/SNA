turtles-own
[
  infected?           ;; if true, the turtle is infectious
  resistant?          ;; if true, the turtle can't be infected
  viral-load          ;;
   ;; avg number of nodes connected to
  virus-check-timer   ;; number of ticks since this turtle's last virus-check
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
  ]

  set-default-shape canaries "triangle"
  create-canaries (number-of-nodes)/(3)
  [
    ; for visual reasons, we don't put any nodes *too* close to the edges
    setxy (random-xcor * 0.95) (random-ycor * 0.95)
    ;; ### become-susceptible
    set virus-check-timer random virus-check-frequency
    set color blue
  ]

  set-default-shape turtles "circle"
  create-turtles (number-of-nodes)/(3)
  [
    ; for visual reasons, we don't put any nodes *too* close to the edges
    setxy (random-xcor * 0.95) (random-ycor * 0.95)
    ;; ### become-susceptible
    set virus-check-timer random virus-check-frequency
    set color green
  ]
end


to setup-spatially-clustered-network
  let num-links (average-node-degree * number-of-nodes) / 2
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
