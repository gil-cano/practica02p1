/**
 * Author: José Emiliano Cabrera Blancas (jemiliano.cabrera@gmail.com)
 *
 */

#include "algorithms/intersection.h"
#include "red_black_tree/rb_tree.h"
#include "red_black_tree/rb_tree.c"


#include <stdio.h>
#include <stdlib.h>


struct double_linked_list* build_required_stops(struct rb_tree* stops,
								struct double_linked_list* edges){
	struct half_edge* tmp_edge;
	struct point *edge_first, *edge_last;
	
	while(!empty_list(edges)){
		printf("tomando la arista del frente de la lista...\n");
		tmp_edge= (struct half_edge*) pick_front(edges);
		printf("Tomando el primer punto\n");
		edge_first=tmp_edge->first;
		printf("Tomando el segundo punto\n");
		edge_last=tmp_edge->last;
		
		printf ("El nodo inicial es: (%lf,%lf)\n", edge_first->x,edge_first->y);
		printf ("El nodo final es: (%lf,%lf)\n", edge_last->x,edge_last->y);
		rb_insert(stops,edge_first);
		rb_insert(stops,edge_last);
		
		pop_front(edges);
	}
}

int is_first(struct point* p){
	struct half_edge* arista=p->half_edge;
	return arista->first== p;
}


void update_intersections(struct rb_tree* state_tree, struct point* point,
										struct rb_tree* intersections ){
	struct rb_node *node, *prev, *next;
	struct half_edge *edge, *prev_edge,*next_edge;
	struct point *prev_point, *next_point, *intersect_point;
	rb_insert(state_tree, point);
	node= rb_node_search(state_tree, point);
	printf("El punto actual del estado es: (%lf,%lf)\n",node->point->x,node->point->y);
	edge= node->point->half_edge;
	
	prev= getPrev(node);
	if(prev != NULL){
		prev_point=prev->point;
		prev_edge=prev_point->half_edge;
		intersect_point= he_intersection(prev_edge,edge);
		if (intersect_point!=NULL){
			
			rb_insert(state_tree, intersect_point);
			rb_insert(intersections, intersect_point);
			
			printf("Intersection found: (%lf,%lf)\n",intersect_point->x,intersect_point->y);
			rb_delete(state_tree,prev_point);
		}
		
	}
	intersect_point=NULL;
	
	
	next= getNext(node);
	if(next != NULL){
		next_point=next->point;
		next_edge=next_point->half_edge;
		intersect_point= he_intersection(next_edge,edge);
		if (intersect_point != NULL){
			rb_insert(state_tree, intersect_point);
			rb_insert(intersections, intersect_point);
			
			printf("Intersection found: (%lf,%lf)\n",intersect_point->x,intersect_point->y);
			rb_delete(state_tree,next_point);
		}
	}
	
	printf("\n");
	
}

struct rb_tree* sweep(struct rb_tree* stops){
	struct rb_tree* state_tree = init_rb_tree(Y);
	struct rb_tree* intersections = init_rb_tree(X);
	
	struct point* current;
	while(!empty_rb_tree(stops)){
		current=rb_min(stops);
		update_intersections(state_tree,current,intersections);
		
		rb_delete(stops,current);
		
	}
	destroy_rb_tree(state_tree);
	destroy_rb_tree(stops);
	return intersections;
	
}







struct double_linked_list* find_intersections(struct double_linked_list*
											  half_edges)
{
	//Código bueno
		if(half_edges != NULL){
			struct double_linked_list* edges= create_copy_list(half_edges);
			struct double_linked_list* intersections= init_double_linked_list(POINT);
			
				if(!empty_list(edges)){ //build sweep line, edge by edge
					struct rb_tree* sweep_line= init_rb_tree(X);
					build_required_stops(sweep_line, edges);
					printf("\n\n\n\n\n\n");
					
					intersections=sweep(sweep_line);
					//Prueba de linea
					 printf("Ya se hizo el barrido de linea\n");
					struct point *equis;
					struct rb_node *nodo;
					while(! empty_rb_tree(intersections)){
						nodo=rb_min_node(intersections);
						equis=nodo->point;
						printf("La intersección actual es: (%lf,%lf)\n", equis->x, equis->y);
						/*if(is_first(equis)){
							printf("Es un punto inicial de una arista\n");
						}else
							printf("Es un punto final de una arista\n");
						*/
						rb_delete(intersections,equis);
					}
					
				}
				return intersections;
		}
		return NULL;
		
		//Código para probar
	/*	
	if(half_edges!=NULL){
		if(!empty_list(half_edges)){
			struct rb_tree *prueba = init_rb_tree(X);
			struct point *actual = init_point(0,2);
			rb_insert(prueba,actual);
			actual= init_point(2,0);
			rb_insert(prueba,actual);
			actual= init_point(1,1);
			rb_insert(prueba,actual);
			actual= init_point(1,0);
			rb_insert(prueba,actual);
			actual= init_point(2,2);
			rb_insert(prueba,actual);
			actual= init_point(2,3);
			rb_insert(prueba,actual);
			actual= init_point(0,1);
			rb_insert(prueba,actual);
			struct point *equis,*prev,*next;
			struct rb_node *nodo,*anterior,*siguiente;
			
			while(!empty_rb_tree(prueba)){
				nodo=rb_max_node(prueba);
				equis=nodo->point;
				printf("El punto actual es: (%lf,%lf)\n", equis->x, equis->y);
				
				printf("Por conseguir el anterior\n");
				anterior= getPrev(X,nodo);
				
				printf("Por conseguir el siguiente\n");
				siguiente= getNext(X,nodo);
				
				rb_delete(prueba,equis);
				printf("\n");
				anterior=siguiente=NULL;
			}
			
			destroy_rb_tree(prueba);
			destroy_rb_node(nodo);
		}
		return init_double_linked_list(POINT);
	}
	return NULL;
	*/
	//Fin código para probar
	
}








