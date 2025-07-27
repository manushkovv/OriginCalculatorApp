import UIKit
import SnapKit

class ViewController: UIViewController {

    // Элементы интерфейса
    private enum Values {
        static let initialResultLabelText = "0"
    }

    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.text = Values.initialResultLabelText
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 40)
        label.backgroundColor = .white
        
        return label
    }()

    private var buttons: [UIButton] = []

    // Переменные для логики калькулятора
    private var currentInput = ""
    private var firstNumber: Double = 0
    private var currentOperation: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // Настройка интерфейса
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(resultLabel)

        // Привязка resultLabel с помощью SnapKit
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }

        // Создание кнопок
        let buttonTitles = ["7", "8", "9", "/",
                            "4", "5", "6", "*",
                            "1", "2", "3", "-",
                            "C", "0", "=", "+"]
        var row = 0
        var column = 0

        buttonTitles.forEach { title in
            let button = createButton(title: title)
            view.addSubview(button)
            buttons.append(button)

            // Привязка кнопок с помощью SnapKit
            button.snp.makeConstraints { make in
                make.width.equalTo(80)
                make.height.equalTo(80)
                make.top.equalTo(resultLabel.snp.bottom).offset(20 + CGFloat(row) * 90)
                make.leading.equalToSuperview().offset(CGFloat(column) * 90 + 20)
            }

            column += 1
            if column > 3 {
                column = 0
                row += 1
            }
        }
    }

    // Создание кнопки
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }

    // Обработка нажатий на кнопки
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }

        if let number = Int(title) {
            currentInput += String(number)
            resultLabel.text = currentInput
        } else if ["+", "-", "*", "/"].contains(title) {
            if !currentInput.isEmpty {
                firstNumber = Double(currentInput) ?? 0
                currentOperation = title
                currentInput = ""
            }
        } else if title == "=" {
            if !currentInput.isEmpty {
                let secondNumber = Double(currentInput) ?? 0
                var result = 0.0

                switch currentOperation {
                case "+": result = firstNumber + secondNumber
                case "-": result = firstNumber - secondNumber
                case "*": result = firstNumber * secondNumber
                case "/": result = firstNumber / secondNumber
                default: break
                }

                resultLabel.text = String(result)
                currentInput = ""
                firstNumber = 0
                currentOperation = ""
            }
        } else if title == "C" {
            currentInput = ""
            firstNumber = 0
            currentOperation = ""
            resultLabel.text = "0"
        }
    }
}
