# -*- coding: utf-8 -*-
# 
# Author: José Emiliano Cabrera Blancas (jemiliano.cabrera@gmail.com)
#

require File.expand_path(File.join(File.dirname(__FILE__), "list_tests"))
require File.expand_path(File.join(File.dirname(__FILE__), "rb_tree_tests"))
require File.expand_path(File.join(File.dirname(__FILE__), "points_tests"))
require File.expand_path(File.join(File.dirname(__FILE__), "half_edge_tests"))
require File.expand_path(File.join(File.dirname(__FILE__), "intersection_tests"))


#
# Reabre el modulo de Test para agregar los metodos que corren las pruebas
#
module Test
  
  # Public: Comprueba si la prueba fue superada o no.
  #
  # message - Mensaje de descripcion de la prueba
  # boolean - Prueba que se ejecuta.
  #
  # Examples
  #
  #    Test.assert("Prueba fake", true)
  #    # => nil
  #
  # Imprime si la prueba fue superada o no.
  def self.assert(message, boolean)
    puts "#{" "*3}#{message}#{" "*(80-message.size)} [PASS]" if boolean
    puts "#{" "*3}#{message}#{" "*(80-message.size)} [FAIL]" if !boolean
    @@test_number += 1 if boolean
  end
  

  # Public: Ejecuta todas las pruebas programadas
  #
  #
  # Examples
  #
  #    Test.run
  #    # => nil
  #
  # Imprime si las pruebas fueron o no superadas.
  def self.run
    puts "Corriendo Tests:\n\n"
    @@test_number = 0
    total_tests = 21
    
    assert("2d_points.h: create_copy_point",TestPoints.create_copy_point)
    puts ""
    
    assert("half_edge.h: copy_half_edge", TestHalfEdge.copy_half_edge)
    assert("half_edge.h: he_intersection", TestHalfEdge.half_edge_intersection)
    puts ""
    
    assert("double_linked_list.h: pop de una lista vacia", TestList.pop_empty_list)
    assert("double_linked_list.h: Mas push, menos pop", TestList.more_push)
    assert("double_linked_list.h: Menos push, mas pop", TestList.more_pop)
    assert("double_linked_list.h: pick de una lista vacia", TestList.pick_empty_list)
    assert("double_linked_list.h: pick en una lista no vacia", TestList.pick)
    puts ""

    assert("rb_tree.h: rb_min en un arbol vacio", TestRBTree.min_on_empty_tree)
    assert("rb_tree.h: rb_max en un arbol vacio", TestRBTree.max_on_empty_tree)
    assert("rb_tree.h: rb_search en un arbol vacio", TestRBTree.search_on_empty_tree)
    assert("rb_tree.h: rb_delete en un arbol vacio", TestRBTree.delete_on_empty_tree)
    assert("rb_tree.h: rb_min", TestRBTree.rb_min)
    assert("rb_tree.h: rb_max", TestRBTree.rb_max)
    assert("rb_tree.h: rb_search",TestRBTree.rb_search)
    assert("rb_tree.h: rb_insert y rb_delete de" + 
           " numberos positivos", TestRBTree.insert_delete_positive_numbers)
    assert("rb_tree.h: rb_insert y rb_delete de" + 
           " numberos negativos", TestRBTree.insert_delete_negative_numbers)
    assert("rb_tree.h: rb_insert y rb_delete de" + 
           " numberos repetidos", TestRBTree.insert_delete_repeat_numbers)
    puts ""
    
    assert("intersection.h: find_intersections recibe nulo como entrada",
           TestIntersection.null_intersection)
    assert("intersection.h: find_intersections recibe una lista vacia",
           TestIntersection.empty_set)
    assert("intersection.h: find_intersections recibe una lista no vacia",
           TestIntersection.not_empty_set)
    puts ""
    
    puts "\nTests aprobados: #{@@test_number}"
    puts "Tests fallidos: #{total_tests - @@test_number}"
  end
end
