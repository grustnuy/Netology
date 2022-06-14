# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

```
C:\Users\Us\Desktop>go version
go version go1.18.3 windows/amd64
```

## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    ```
    package main
        
    import "fmt"     
    import "math"
        
        func main() {
            fmt.Print("Enter value in foot: ")
            var input float64
            fmt.Scanf("%f", &input)           
            output := input * float64(0.3048) 
            fmt.Println("Value in Meters:", output)    
        }
    ```
	
	
- Результат:
	```
	C:\Users\Us\Desktop>go run conv.go
	Enter value in foot: 100
	Value in Meters: 30.48
 	```
 
 
1. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:

	
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
   
    
    ```
	package main
        
    import "fmt"
        
        func main() {
            x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
            current := 0
            fmt.Println ("Список значений : ", x)
            for i, value := range x {
                if (i == 0) {
                   current = value 
                } else {
                    if (value < current){
                        current = value
                    }
                }
            }
            fmt.Println("Минимальное число : ", current)
        }
	```	
- Результат:
	```
	C:\Users\Us\Desktop>go run conv.go
	Список значений :  [48 96 86 68 57 82 63 70 37 34 83 27 19 97 9 17]
	Минимальное число :  9	
	```
	
1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

	```
	package main
        
    import "fmt"       
        
        func main() {
            
            for i := 1; i <= 100; i++ {
                if ((i-1)%10) ==0 {
                        fmt.Print(i-1," -> ")
                }            
                        
                if (i%3) == 0 {
                    fmt.Print(i,", ")
                    }
                if (i%10) ==0 {
                    fmt.Println()
                }
            }
        }
	```

- Результат:
	```
	C:\Users\Us\Desktop>go run del3.go
	0 -> 3, 6, 9,
	10 -> 12, 15, 18,
	20 -> 21, 24, 27, 30,
	30 -> 33, 36, 39,
	40 -> 42, 45, 48,
	50 -> 51, 54, 57, 60,
	60 -> 63, 66, 69,
	70 -> 72, 75, 78,
	80 -> 81, 84, 87, 90,
	90 -> 93, 96, 99,
	```
