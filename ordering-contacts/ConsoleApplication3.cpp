#include <stdio.h>
#include <string.h>

// assembly tarafinda anlasilmayan noktalar icin isterseniz iletisime gecebilirsiniz (nur.morca@std.yildiz.edu.tr)
// RELEASE modda calismasi:
// fscanf sscanf hatasi icin 
// [project] -> properties ->C\C++ -> PreProcessor kismina "_CRT_SECURE_NO_WARNINGS" komutu eklendi.
// linkleme esnasinda cikan SAFESEH hatasi icin
// [project] -> properties -> linker -> advanced -> "Image has safe exception handlers" YES'ten NO'ya cevrildi.

#define N 10
#define SURNAME_SIZE 15
#define NAME_SIZE 15
#define NUMBER_SIZE 9
#define FILE_SIZE 39*N

typedef struct {
	char surname[SURNAME_SIZE + 1];
	char name[NAME_SIZE + 1];
	char number[NUMBER_SIZE + 1];
} Person;

extern "C" void selsortasm(Person*, int, int);


int main() {
	FILE *file = fopen("C:\\Users\\nur\\CLionProjects\\untitled1\\people.txt", "r");


	if (file == NULL) {
		perror("Error opening file");
		return 1;
	}

	char buffer[FILE_SIZE + 1];
	fread(buffer, sizeof(char), FILE_SIZE, file);
	buffer[FILE_SIZE] = '\0';

	fclose(file);

	Person people[N];

	int num_people;
	sscanf(buffer, "%d", &num_people);


	char *token = strtok(buffer + sizeof(int), "\n"); // Skip the first line
	for (int i = 0; i < num_people; i++) {

		strncpy(people[i].surname, token, SURNAME_SIZE);
		people[i].surname[SURNAME_SIZE] = '\0';
		token += SURNAME_SIZE;

		strncpy(people[i].name, token, NAME_SIZE);
		people[i].name[NAME_SIZE] = '\0';
		token += NAME_SIZE;

		strncpy(people[i].number, token, NUMBER_SIZE);
		people[i].number[NUMBER_SIZE] = '\0';
		token += NUMBER_SIZE;

		token = strtok(NULL, "\n");
	}

	for (int i = 0; i < num_people; i++) {
		printf("Person %d:\n", i + 1);
		printf("Surname: %s\n", people[i].surname);
		printf("Name: %s\n", people[i].name);
		printf("Number: %s\n", people[i].number);
		printf("\n");

	}


	int option;
	do {
		printf("\nOrder by:\n1) Surname\n2) Name\n3) Number\nEnter your choice: ");
		scanf("%d", &option);
	} while (option < 1 || option > 3);



	selsortasm(people, num_people, option);



	for (int i = 0; i < num_people; i++) {
		printf("Person %d:\n", i + 1);
		printf("Surname: %s\n", people[i].surname);
		printf("Name: %s\n", people[i].name);
		printf("Number: %s\n", people[i].number);
		printf("\n");

	}



	return 0;
}