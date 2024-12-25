package com.example.first_mvp;

import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import androidx.gridlayout.widget.GridLayout;
import android.widget.ImageButton;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.activity.OnBackPressedCallback;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class FirstExercise extends AppCompatActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_first_exercise);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        Button button1 = findViewById(R.id.button4);
        Button button2 = findViewById(R.id.button5);
        Button button3 = findViewById(R.id.button6);
        Button buttonToNextPage = findViewById(R.id.buttonToNextPage);

        button1.setOnClickListener(v -> changeButtonColor((Button) v, "#FCC35454"));
        button2.setOnClickListener(v -> {changeButtonColor((Button) v, "#5AAF4F");
            buttonToNextPage.setVisibility(View.VISIBLE);
        });
        button3.setOnClickListener(v -> changeButtonColor((Button) v, "#FCC35454"));

        buttonToNextPage.setOnClickListener(v -> {
            Intent intent = new Intent(this, SecondExercise.class);
            startActivity(intent);
        });

        ImageButton goBackBtw1 = findViewById(R.id.goBackBtw1);
        goBackBtw1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showInfoAlert("Вы действительно хотите закрыть тренировку?");
            }
        });

        getOnBackPressedDispatcher().addCallback(this, new OnBackPressedCallback(true) {
            @Override
            public void handleOnBackPressed() {
                // Показываем окно подтверждения
                showInfoAlert("Вы действительно хотите закрыть тренировку?");
            }
        });



        GridLayout gridLayout = findViewById(R.id.gridLayoutMatrix1);

        int[][] matrix = {
                {1, 2, 1},
                {0, 1, 0},
                {2, 1, 3}
        };

        // Устанавливаем размеры и стилизуем каждую ячейку
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                TextView textView = new TextView(this);
                textView.setText(String.valueOf(matrix[i][j]));
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


    public void turnBack(View v){
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);
    }

    private void showInfoAlert(String text) {
        AlertDialog.Builder builder = new AlertDialog.Builder(FirstExercise.this);
        builder.setTitle("Выход из тренировки")
                .setMessage(text)
                .setCancelable(true)
                .setPositiveButton("Да", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        Intent intent = new Intent(FirstExercise.this, MainActivity.class);
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

    private void changeButtonColor(Button button, String colorHex) {
        button.setBackgroundTintList(ColorStateList.valueOf(Color.parseColor(colorHex)));
    }
}