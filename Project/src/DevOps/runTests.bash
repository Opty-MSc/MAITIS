FRONT_IP=$(terraform output -raw frontend)

diff ../TestOut/add_1_1.out <(curl "http://$FRONT_IP:8090/?OP=add&X=1&Y=1") || exit 1
diff ../TestOut/sub_1_1.out <(curl "http://$FRONT_IP:8090/?OP=sub&X=1&Y=1") || exit 1
diff ../TestOut/mul_1_1.out <(curl "http://$FRONT_IP:8090/?OP=mul&X=1&Y=1") || exit 1
diff ../TestOut/div_1_1.out <(curl "http://$FRONT_IP:8090/?OP=div&X=1&Y=1") || exit 1

diff ../TestOut/add_5_5.out <(curl "http://$FRONT_IP:8090/?OP=add&X=5&Y=5") || exit 1
diff ../TestOut/sub_5_5.out <(curl "http://$FRONT_IP:8090/?OP=sub&X=5&Y=5") || exit 1
diff ../TestOut/mul_5_5.out <(curl "http://$FRONT_IP:8090/?OP=mul&X=5&Y=5") || exit 1
diff ../TestOut/div_5_5.out <(curl "http://$FRONT_IP:8090/?OP=div&X=5&Y=5") || exit 1

diff ../TestOut/add_-10_-10.out <(curl "http://$FRONT_IP:8090/?OP=add&X=-10&Y=-10") || exit 1
diff ../TestOut/sub_-10_-10.out <(curl "http://$FRONT_IP:8090/?OP=sub&X=-10&Y=-10") || exit 1
diff ../TestOut/mul_-10_-10.out <(curl "http://$FRONT_IP:8090/?OP=mul&X=-10&Y=-10") || exit 1
diff ../TestOut/div_-10_-10.out <(curl "http://$FRONT_IP:8090/?OP=div&X=-10&Y=-10") || exit 1
