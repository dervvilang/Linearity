package com.example.first_mvp;

import android.annotation.SuppressLint;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.activity.OnBackPressedCallback;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.gridlayout.widget.GridLayout;

public class SecondExercise extends AppCompatActivity {

    EditText exerciseTwo;

    @SuppressLint("MissingInflatedId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_second_exercise);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        exerciseTwo = findViewById(R.id.exerciseTwo);

        ImageButton goBackBtw2 = findViewById(R.id.goBackBtw2);
        goBackBtw2.setOnClickListener(v -> showInfoAlert());


        getOnBackPressedDispatcher().addCallback(this, new OnBackPressedCallback(true) {
            @Override
            public void handleOnBackPressed() {
                AlertDialog.Builder builder = new AlertDialog.Builder(SecondExercise.this);
                builder.setTitle("Выход из тренировки")
                        .setMessage("Вы действительно хотите закрыть тренировку?")
                        .setCancelable(true)
                        .setPositiveButton("Да", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                Intent intent = new Intent(SecondExercise.this, MainActivity.class);
                                startActivity(intent);
                            }
                        })
                        .setNegativeButton("Нет", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                            }
                        }).show();
            }
        });




        GridLayout gridLayout = findViewById(R.id.gridLayoutMatrix2);

        int[][] matrix = {
                {3, 0, 1},
                {0, 2, 0},
                {5, 0, 4}
        };

        // Устанавливаем размеры и стилизуем каждую ячейку
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                TextView textView = new TextView(this);
                textView.setText(String.valueOf(matrix[i][j])); // Пример: нумерация от 1 до 9
                textView.setGravity(Gravity.CENTER);
                textView.setBackgroundResource(R.drawable.cell_background); // Фон ячейки
                textView.setTextColor(Color.WHITE);
                textView.setTextSize(20); // Размер текста
                textView.setPadding(16, 16, 16, 16); // Внутренние отступы

                // Устанавливаем параметры для каждой ячейки
                GridLayout.LayoutParams params = new GridLayout.LayoutParams();
                params.rowSpec = GridLayout.spec(i);
                params.columnSpec = GridLayout.spec(j);
                params.setMargins(8, 8, 8, 8); // Отступы между ячейками
                params.width = 0; // Равномерное распределение ширины
                params.height = 0; // Равномерное распределение высоты
                params.columnSpec = GridLayout.spec(j, 1f);
                params.rowSpec = GridLayout.spec(i, 1f);

                textView.setLayoutParams(params);
                gridLayout.addView(textView);
            }
        }
    }

    private void showInfoAlert() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Выход из тренировки")
                .setMessage("Вы действительно хотите закрыть тренировку?")
                .setCancelable(true)
                .setPositiveButton("Да", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        Intent intent = new Intent(SecondExercise.this, MainActivity.class);
                        startActivity(intent);
                    }
                })
                .setNegativeButton("Нет", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                }).show();
    }

    public void goStart(View v) {
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);
    }

    public void turnBack(View v) {
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);
    }

    public void checkNumber(View view) {
        hideKeyboard();

        String inputText = exerciseTwo.getText().toString();
        if (inputText.isEmpty()) return;

        Button buttonToFirstPage = findViewById(R.id.buttonToFirstPage);

        int number = Integer.parseInt(inputText);

        if (number == 14) {
            exerciseTwo.setTextColor(Color.GREEN);
            buttonToFirstPage.setVisibility(View.VISIBLE);

        } else {
            exerciseTwo.setTextColor(Color.RED);
        }
    }

    private void hideKeyboard() {
        View view = this.getCurrentFocus(); // Получаем текущий активный элемент
        if (view != null) {
            InputMethodManager imm = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(view.getWindowToken(), 0); // Скрываем клавиатуру
        }
    }
}
