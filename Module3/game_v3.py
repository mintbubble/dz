import numpy as np


def game_core_v3(number: int = 1) -> int:
    """
    Args:
        number (int, optional): Загаданное число. Defaults to 1.

    Returns:
        int: Число попыток
    """
    # Ваш код начинается здесь

    count = 0  # счетчик
    minimum = 1  # нижняя граница диапазона
    maximum = 101  # верхняя граница диапазона
    predict_number = np.random.randint(minimum, maximum)  # генерируем число

    while True:
        count += 1
        if number == predict_number:
            break  # выход из цикла если угадали
        else:
            if number > predict_number:
                minimum = predict_number  # меняем нижнюю границу диапазона
                predict_number = np.random.randint(minimum, maximum)
            else:
                maximum = predict_number  # меняем верхнюю границу диапазона
                predict_number = np.random.randint(minimum, maximum)

    # Ваш код заканчивается здесь

    return count


def score_game(random_predict) -> int:
    """За какое количество попыток в среднем за 1000 подходов
    угадывает наш алгоритм

    Args:
        random_predict ([type]): функция угадывания

    Returns:
        int: среднее количество попыток
    """
    count_ls = []
    # np.random.seed(1)  # фиксируем сид для воспроизводимости
    random_array = np.random.randint(1, 101, size=(1000))  # загадали числа

    for number in random_array:
        count_ls.append(random_predict(number))

    score = int(np.mean(count_ls))
    print(f"Ваш алгоритм угадывает число в среднем за: {score} попыток")
    return score


if __name__ == "__main__":
    # RUN
    score_game(game_core_v3)
